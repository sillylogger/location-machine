# Taken from:
# https://gist.github.com/dinatih/dbfdfd4e84faac4037448a06c9fdc016
# Really has me questioning if ActiveStorage is ready, I'll keep hacking
# it together and this feature will eventually be added :-/

Rails.application.config.to_prepare do
  # Provides the class-level DSL for declaring that an Active Record model has attached blobs.
  ActiveStorage::Attached::Macros.module_eval do
    def has_one_attached(name, dependent: :purge_later, acl: :private)
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}
          @active_storage_attached_#{name} ||= ActiveStorage::Attached::One.new("#{name}", self, dependent: #{dependent == :purge_later ? ":purge_later" : "false"}, acl: "#{acl}")
        end
        def #{name}=(attachable)
          #{name}.attach(attachable)
        end
      CODE

      has_one :"#{name}_attachment", -> { where(name: name) }, class_name: "ActiveStorage::Attachment", as: :record, inverse_of: :record, dependent: false
      has_one :"#{name}_blob", through: :"#{name}_attachment", class_name: "ActiveStorage::Blob", source: :blob

      scope :"with_attached_#{name}", -> { includes("#{name}_attachment": :blob) }

      if dependent == :purge_later
        after_destroy_commit { public_send(name).purge_later }
      else
        before_destroy { public_send(name).detach }
      end
    end

    def has_many_attached(name, dependent: :purge_later, acl: :private)
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}
          @active_storage_attached_#{name} ||= ActiveStorage::Attached::Many.new("#{name}", self, dependent: #{dependent == :purge_later ? ":purge_later" : "false"}, acl: "#{acl}")
        end
        def #{name}=(attachables)
          #{name}.attach(attachables)
        end
      CODE

      has_many :"#{name}_attachments", -> { where(name: name) }, as: :record, class_name: "ActiveStorage::Attachment", inverse_of: :record, dependent: false do
        def purge
          each(&:purge)
          reset
        end

        def purge_later
          each(&:purge_later)
          reset
        end
      end
      has_many :"#{name}_blobs", through: :"#{name}_attachments", class_name: "ActiveStorage::Blob", source: :blob

      scope :"with_attached_#{name}", -> { includes("#{name}_attachments": :blob) }

      if dependent == :purge_later
        after_destroy_commit { public_send(name).purge_later }
      else
        before_destroy { public_send(name).detach }
      end
    end
  end

  ActiveStorage::Blob.class_eval do
    def service_url(expires_in: service.url_expires_in, disposition: :inline, filename: nil, **options)
      filename = ActiveStorage::Filename.wrap(filename || self.filename)
      expires_in = false if metadata[:acl] == 'public'
      service.url key, expires_in: expires_in, filename: filename, content_type: content_type,
                       disposition: forcibly_serve_as_binary? ? :attachment : disposition, **options
    end

    def upload(io)
      self.checksum     = compute_checksum_in_chunks(io)
      self.content_type = extract_content_type(io)
      self.byte_size    = io.size
      self.identified   = true
      service.upload(key, io, checksum: checksum, acl: metadata[:acl])
    end
  end

  ActiveStorage::Attached.class_eval do
    attr_reader :name, :record, :dependent, :acl

    def initialize(name, record, dependent:, acl: 'private')
      @name, @record, @dependent, @acl = name, record, dependent, acl
    end

    private

      def create_blob_from(attachable)
        case attachable
        when ActiveStorage::Blob
          attachable
        when ActionDispatch::Http::UploadedFile, Rack::Test::UploadedFile
          ActiveStorage::Blob.create_after_upload! \
            io: attachable.open,
            filename: attachable.original_filename,
            content_type: attachable.content_type,
            metadata: { acl: acl }
        when Hash
          ActiveStorage::Blob.create_after_upload!({ metadata: { acl: acl } }.deep_merge(attachable))
        when String
          ActiveStorage::Blob.find_signed(attachable)
        else
          nil
        end
      end
  end

  if defined?(ActiveStorage::Service)
    ActiveStorage::Service.class_eval do
      def upload(key, io, checksum: nil, acl: 'private')
        raise NotImplementedError
      end
    end
  end

  if defined?(ActiveStorage::Service::DiskService)
    ActiveStorage::Service::DiskService.class_eval do
      def upload(key, io, checksum: nil, acl: 'private')
        instrument :upload, key: key, checksum: checksum do
          IO.copy_stream(io, make_path_for(key))
          ensure_integrity_of(key, checksum) if checksum
        end
      end
    end
  end

  if defined?(ActiveStorage::Service::GCSService)
    # from activestorage/lib/active_storage/service/gcs_service.rb
    ActiveStorage::Service::GCSService.class_eval do
      def upload(key, io, checksum: nil, acl: 'private')
        instrument :upload, key: key, checksum: checksum, acl: acl do
          begin
            # The official GCS client library doesn't allow us to create a file with no Content-Type metadata.
            # We need the file we create to have no Content-Type so we can control it via the response-content-type
            # param in signed URLs. Workaround: let the GCS client create the file with an inferred
            # Content-Type (usually "application/octet-stream") then clear it.
            bucket.create_file(io, key, md5: checksum, acl: acl, cache_control: acl == 'public' ? 'public, max-age=3600' : nil).update do |file|
              file.content_type = nil
            end
          rescue Google::Cloud::InvalidArgumentError
            raise ActiveStorage::IntegrityError
          end
        end
      end

      def url(key, expires_in:, filename:, disposition:, content_type:)
        instrument :url, key: key, expires_in: expires_in do |payload|
          generated_url = if expires_in == false
                            file_for(key).public_url
                          else
                            file_for(key).signed_url expires: expires_in, query: {
                              "response-content-disposition" => content_disposition_with(type: disposition, filename: filename),
                              "response-content-type" => content_type
                            }
                          end


          payload[:url] = generated_url

          generated_url
        end
      end
    end

  end
end

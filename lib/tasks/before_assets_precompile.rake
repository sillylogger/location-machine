
task :before_assets_precompile do

  puts "Before Assets Precompile"
  puts "Dir: #{Dir.pwd}"

  Dir.chdir 'brunch' do
    puts "Dir: #{Dir.pwd}"
    system('npm install')
    system('./node_modules/.bin/brunch build')
  end

end

Rake::Task['assets:precompile'].enhance ['before_assets_precompile']


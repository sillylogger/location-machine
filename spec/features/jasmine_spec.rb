describe "the jasmine specs" do

  it "has no errors" do
    @page = JasminePage.new
    @page.load

    wait_until 20.seconds do
      @page.finished?
    end

    failures = @page.failures.map(&:to_s)
    expect(failures).to eq([])
  end

end


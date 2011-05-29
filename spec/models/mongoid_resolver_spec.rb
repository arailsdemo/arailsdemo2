require "spec_helper"

describe MongoidResolver do
  let(:klass) { MongoidResolver }

  it "inherits from BaseResolver" do
    klass.ancestors.should include BaseResolver
  end

  it "is a singleton class" do
    expect { subject }.to raise_error NoMethodError
    klass.should respond_to :instance
  end
end

require "spec_helper"

describe Spore::Environment::Substitutions do
  before { ENV["VARIABLE"] = "chunky bacon" }

  shared_examples_for "resolves correctly" do |output|
    it "resolves to #{output}" do
      expect(described_class.call(value)).to eq(output)
    end
  end  # shared_examples_for "resolves correctly"

  context "for a variable without any substitution" do
    let(:value) { "I can count to potato!" }
    it_behaves_like "resolves correctly", "I can count to potato!"
  end  # context "for a variable without any substitution"

  context "for a valid variable without curly braces" do
    let(:value) { "I <3 $VARIABLE!" }
    it_behaves_like "resolves correctly", "I <3 chunky bacon!"
  end  # context "for a valid variable without curly braces"

  context "for a valid variable with curly braces" do
    let(:value) { "I <3 ${VARIABLE}!" }
    it_behaves_like "resolves correctly", "I <3 chunky bacon!"
  end  # context "for a valid variable with curly braces"

  context "for an escaped variable without curly braces" do
    let(:value) { "I <3 \\$VARIABLE!" }
    it_behaves_like "resolves correctly", "I <3 \$VARIABLE!"
  end  # context "for an escaped variable without curly braces"

  context "for an escaped variable with curly braces" do
    let(:value) { "I <3 \\${VARIABLE}!" }
    it_behaves_like "resolves correctly", "I <3 \${VARIABLE}!"
  end  # context "for an escaped variable with curly braces"

  context "for a variable with unbalanced curly braces" do
    let(:value) { "I <3 \\${VARIABLE!" }
    it_behaves_like "resolves correctly", "I <3 \${VARIABLE!"
  end  # context "for an escaped variable with curly braces"
end  # describe Spore::Environment::Substitutions

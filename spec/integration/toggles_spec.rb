describe "Integration::ToggleService" do
  before do
    TogglesStub.enable "test-enabled-feature": true,
                       "test-disabled-feature": false

    loader_enable_original "helper/toggles"
  end

  after do
    Helper::Toggles.shutdown!
    loader_enable_override "helper/toggles"
  end

  context "with a known feature toggle" do
    it "feature test-enabled-feature is active" do
      expect(Helper::Toggles.enabled?("test-enabled-feature")).to be(true)
    end

    it "feature test-disabled-feature is not active" do
      expect(Helper::Toggles.enabled?("test-disabled-feature")).to be(false)
    end

    context "when a block is passed" do
      block_executed = nil

      before do
        block_executed = false
        Helper::Toggles.enabled?("test-enabled-feature") { block_executed = true }
      end

      it "executes the block" do
        expect(block_executed).to be true
      end
    end
  end

  context "with an unknown feature toggle" do
    it "feature test-unknown-feature is not active" do
      expect(Helper::Toggles.enabled?("test-unknown-feature")).to be(false)
    end

    it "feature test-unknown-feature is active if given true default" do
      expect(
        Helper::Toggles.enabled?("test-unknown-feature", default: true),
      ).to be(true)
    end

    context "when a block is passed" do
      block_executed = nil

      before do
        block_executed = false
        Helper::Toggles.enabled?("test-unknown-feature") { block_executed = true }
      end

      it "does not execute the block" do
        expect(block_executed).to be false
      end
    end
  end
end

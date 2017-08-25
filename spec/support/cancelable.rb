shared_examples_for "cancelable" do
  let(:model_name) { described_class.model_name }

  describe "#cancel", :freeze_time do
    let(:instance) { create(model_name, canceled_at: nil) }

    it "updates canceled_at to current time" do
      expect { instance.cancel }.to change { instance.canceled_at }.to(Time.current)
    end

    context "when called with a time argument" do
      let(:time) { 1.hours.from_now }

      it "updates canceled_at with it" do
        expect { instance.cancel(time) }.to change { instance.canceled_at }.to(time)
      end
    end
  end

  describe "#restore" do
    let(:instance) { create(model_name, canceled_at: Time.current) }

    it "updates canceled_at to nil" do
      expect { instance.restore }.to change { instance.canceled_at }.to(nil)
    end
  end

  describe ".visible" do
    let!(:visible_instance) { create(model_name, canceled_at: nil) }
    let!(:canceled_instance) { create(model_name, canceled_at: Time.current) }

    it "returns visible objects" do
      expect(described_class.visible).to eq [visible_instance]
    end
  end

  describe ".canceled" do
    let!(:canceled_instance) { create(model_name, canceled_at: Time.current) }
    let!(:visible_instance) { create(model_name, canceled_at: nil) }

    it "returns canceled objects" do
      expect(described_class.canceled).to eq [canceled_instance]
    end
  end

  describe "#visible?" do
    context "when canceled_at is nil" do
      let(:instance) { build(model_name, canceled_at: nil) }

      it { expect(instance.visible?).to eq true }
    end

    context "when canceled_at is present" do
      let(:instance) { build(model_name, canceled_at: Time.current) }

      it { expect(instance.visible?).to eq false }
    end
  end

  describe "#canceled?" do
    context "when canceled_at is nil" do
      let(:instance) { build(model_name, canceled_at: nil) }

      it { expect(instance.canceled?).to eq false }
    end

    context "when canceled_at is present" do
      let(:instance) { build(model_name, canceled_at: Time.current) }

      it { expect(instance.canceled?).to eq true }
    end
  end
end

require 'as_json_presentable'
require 'as_json_presentable/presenter'

describe AsJsonPresentable do

  class PresentablePresenter < AsJsonPresentable::Presenter
    JSON = { special: true }

    def as_special_json(options=nil)
      JSON
    end
  end

  class RandomPresenter < AsJsonPresentable::Presenter
    JSON = { random: true }

    def as_random_json(options=nil)
      JSON
    end
  end

  class Base
    def as_json(options=nil)
      self.class::BASE_JSON
    end
  end

  class NonPresentable < Base
    include AsJsonPresentable # No presenter (implicit or explicit), and so still not presentable

    BASE_JSON = { presentable: false }
  end

  class Presentable < Base
    include AsJsonPresentable

    BASE_JSON = { presentable: true }
  end

  class ExplicitPresentable < Base
    include AsJsonPresentable
    define_json_presenter_class RandomPresenter

    BASE_JSON = { explicit: true }
  end


  describe "#as_json" do
    context "with a presentable class" do
      let(:options) { Hash.new }
      subject { Presentable.new }
      let(:results) { subject.as_json(options) }

      context "with :presenter_action specified" do
        let(:options) { { presenter_action: :special } }

        it "delegates to the presenter" do
          expect(results).to eq PresentablePresenter::JSON
        end
      end

      context "without a :presenter_action" do
        it "uses its base #as_json implementation" do
          expect(results).to eq Presentable::BASE_JSON
        end
      end
    end

    context "with a non-presentable class" do
      let(:options) { Hash.new }
      subject { NonPresentable.new }
      let(:results) { subject.as_json(options) }

      context "with :presenter_action specified" do
        let(:options) { { presenter_action: :random } }

        it "uses its base #as_json implementation" do
          expect(results).to eq NonPresentable::BASE_JSON
        end
      end

      context "without a :presenter_action" do
        it "uses its base #as_json implementation" do
          expect(results).to eq NonPresentable::BASE_JSON
        end
      end
    end
  end

  describe "#json_presenter_class" do

    context "with an inferred presenter class" do
      subject { Presentable.new }

      it "returns the inferred class" do
        expect(subject.json_presenter_class).to eq PresentablePresenter
      end
    end

    context "with an explicit presenter class" do
      subject { ExplicitPresentable.new }

      it "returns the specified class" do
        expect(subject.json_presenter_class).to eq RandomPresenter
      end
    end

    context "with no implicit or explicit presenter class" do
      it "returns nil" do
        expect(NonPresentable.new.json_presenter_class).to be_nil
      end
    end
  end

  describe ".define_json_presenter_class" do
    it "specifies the presenter" do
      expect(ExplicitPresentable.new.json_presenter_class).to eq RandomPresenter
    end
  end

end

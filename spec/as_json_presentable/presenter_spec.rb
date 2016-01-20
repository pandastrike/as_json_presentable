require 'as_json_presentable/presenter'

module AsJsonPresentable

  describe Presenter do
    class TestPresenter < Presenter
      TEST_JSON_RESPONSE = :test_json_response

      def as_test_action_json(options=nil)
        TEST_JSON_RESPONSE
      end
    end

    let(:resource) { double("Resource") }
    subject { TestPresenter.new(resource) }

    describe "#as_json" do

      context "without the :presenter_action option" do
        it "falls back to the resource's #as_json" do
          expect(resource).to receive(:as_json).once
          subject.as_json
        end
      end

      context "with an invalid :presenter_action" do
        it "raises an InvalidPresenterAction exception" do
          expect {
            subject.as_json(presenter_action: :invalid_action)
          }.to raise_error(InvalidPresenterAction)
        end
      end

      context "with a valid :presenter_action" do
        it "calls the presenter action" do
          expect(resource).to_not receive(:as_json)
          expect(subject.as_json(presenter_action: :test_action)).to eq TestPresenter::TEST_JSON_RESPONSE
        end
      end
    end

    describe "#as_error_json" do

      context "without the :error presenter defined; should call base class" do
        it "falls back to the resource's #as_error_json" do
          expect(resource).to receive(:errors).once
          subject.as_error_json
        end

      end
    end

  end
end

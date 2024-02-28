describe "Domestic EPCs Smart meters section", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

  context "when both smart meter value are set to nil" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1234-5678-1234-5678-1234",
      )
    end

    it "does not show the smart meter in the contents" do
      expect(response.body).not_to have_css("div.component__contents", text: "Smart meters")
    end

    it "does not show the smart meter section" do
      expect(response.body).not_to have_css("div#smart-meters")
    end
  end

  context "when the smart meter values are not set to nil" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1234-5678-1234-5678-1234",
        gas_smart_meter_present: false,
        electricity_smart_meter_present: true,
      )
    end

    it "shows smart meter in the contents" do
      expect(response.body).to have_css("div.component__contents", text: "Smart meters")
    end

    it "has the smart meters heading" do
      expect(response.body).to have_css "div#smart-meters h2", text: "Smart meters"
    end

    it "has the smart meters body1 text" do
      expect(response.body).to have_css "div#smart-meters p", text: "This property had "
    end

    it "has the smart meters body2 text" do
      expect(response.body).to have_css "div#smart-meters p", text: " when it was assessed."
    end

    it "has the smart meters explanation" do
      expect(response.body).to have_css "div#smart-meters p", text: "Smart meters help you understand your energy use and how you could save money. They may help you access better energy deals."
    end

    context "when a gas and electricity smart mater are both present" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-5678-1234-5678-1234",
          gas_smart_meter_present: true,
          electricity_smart_meter_present: true,
        )
      end

      it "has the gas and electricity text" do
        expect(response.body).to have_css("div#smart-meters", text: "smart meters for gas and electricity")
      end

      it "has the correct link" do
        expect(response.body).to have_link("Find out about using your smart meter", href: "https://www.smartenergygb.org/using-your-smart-meter")
      end
    end

    context "when there is only a gas smart meter present" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-5678-1234-5678-1234",
          gas_smart_meter_present: true,
          electricity_smart_meter_present: false,
        )
      end

      it "has the gas only text" do
        expect(response.body).to have_css("div#smart-meters", text: "a smart meter for gas")
      end

      it "has the correct link" do
        expect(response.body).to have_link("Find out about using your smart meter", href: "https://www.smartenergygb.org/using-your-smart-meter")
      end
    end

    context "when there is only a electricity smart meter present" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-5678-1234-5678-1234",
          gas_smart_meter_present: false,
          electricity_smart_meter_present: true,
        )
      end

      it "has the electricity text" do
        expect(response.body).to have_css("div#smart-meters", text: "smart meter for electricity")
      end

      it "has the correct link" do
        expect(response.body).to have_link("Find out about using your smart meter", href: "https://www.smartenergygb.org/using-your-smart-meter")
      end
    end

    context "when neither smart meters are present" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-5678-1234-5678-1234",
          gas_smart_meter_present: false,
          electricity_smart_meter_present: false,
        )
      end

      it "has the text for no smart meters" do
        expect(response.body).to have_css("div#smart-meters", text: "no smart meters")
      end

      it "has the correct link" do
        expect(response.body).to have_link("Find out how to get a smart meter", href: "https://www.smartenergygb.org/")
      end
    end
  end
end

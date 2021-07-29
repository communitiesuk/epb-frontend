# frozen_string_literal: true

module AssessorsGateway
  class Stub
    def search_by_postcode(*)
      {
        data: {
          assessors: [
            {
              "firstName": "Gregg",
              "lastName": "Sellen",
              "contactDetails": {
                "telephoneNumber": "0792 102 1368",
                "email": "epbassessor@epb.com",
              },
              "searchResultsComparisonPostcode": "SW1A 1AA",
              "registeredBy": {
                "schemeId": "432",
                "name": "EPBs 4 U",
              },
              "distanceFromPostcodeInMiles": 0.1,
            },
            {
              "firstName": "Juliet",
              "lastName": "Montague",
              "contactDetails": {
                "telephoneNumber": "0792 102 1368",
                "email": "epbassessor@epb.com",
              },
              "searchResultsComparisonPostcode": "SW1A 1AA",
              "registeredBy": {
                "schemeId": "432",
                "name": "EPBs 4 U",
              },
              "distanceFromPostcodeInMiles": 0.3,
            },
          ],
        },
        meta: {
          "timestamp": 1_234_567,
          "searchPostcode": "SW1 5RW",
        },
      }
    end

    def search_by_name(name, qualification_type)
      {
        data: {
          assessors: [
            {
              "firstName": "Somewhatcommon",
              "lastName": "Name",
              "contactDetails": {
                "telephoneNumber": "0792 102 1368",
                "email": "epbassessor@epb.com",
              },
              "qualifications": qualifications(qualification_type),
              "searchResultsComparisonPostcode": "SW1A 1AA",
              "registeredBy": {
                "schemeId": "432",
                "name": "EPBs 4 U",
              },
              "distanceFromPostcodeInMiles": 0.1,
            },
            {
              "firstName": "Somewhatcommon",
              "lastName": "Name",
              "contactDetails": {
                "telephoneNumber": "0792 102 1368",
                "email": "epbassessor@epb.com",
              },
              "qualifications": qualifications(qualification_type),
              "searchResultsComparisonPostcode": "SW1A 1AA",
              "registeredBy": {
                "schemeId": "432",
                "name": "EPBs 4 U",
              },
              "distanceFromPostcodeInMiles": 0.3,
            },
          ],
        },
        meta: {
          "timestamp": 1_234_567,
          "searchName": name,
          "looseMatch": false,
        },
      }
    end

    def qualifications(type)
      if type == "domestic"
        {
          "domesticRdSap": "ACTIVE",
          "domesticSap": "ACTIVE",
        }
      else
        {
          "nonDomesticDec": "ACTIVE",
          "nonDomesticNos3": "ACTIVE",
          "nonDomesticNos4": "ACTIVE",
          "nonDomesticNos5": "ACTIVE",
          "nonDomesticSp3": "ACTIVE",
          "nonDomesticCc4": "ACTIVE",
        }
      end
    end
  end
end

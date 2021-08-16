# frozen_string_literal: true

module FindAssessor
  module ByName
    class Stub
      def self.search_by_name(name, qualification_type = "", loose_match: false)
        WebMock
          .stub_request(
            :get,
            "http://test-api.gov.uk/api/assessors?name=#{name}&qualificationType=#{qualification_type}",
          )
          .with(
            headers: {
              :Accept => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              :Authorization => "Bearer abc",
            },
          )
          .to_return(
            status: 200,
            body: {
              "data": {
                "assessors": [
                  {
                    "firstName": "Supercommon",
                    "lastName": "Name",
                    "contactDetails": {
                      "telephoneNumber": "string",
                      "email": "UPPERCASE_EMAIL@eXaMpLe.com",
                    },
                    "qualifications": qualifications(qualification_type),
                    "searchResultsComparisonPostcode": "SW1A 1AA",
                    "registeredBy": {
                      "schemeId": "432",
                      "name": "CIBSE",
                    },
                    "schemeAssessorId": "CIBSE9999990",
                  },
                  {
                    "firstName": "Supercommon",
                    "lastName": "Name",
                    "contactDetails": {
                      "telephoneNumber": "string",
                      "email": "user@example.com",
                    },
                    "qualifications": qualifications(qualification_type),
                    "searchResultsComparisonPostcode": "SW1A 1AA",
                    "registeredBy": {
                      "schemeId": "444",
                      "name": "Stroma",
                    },
                    "schemeAssessorId": "Stroma9999990",
                  },
                  {
                    "firstName": "Name",
                    "lastName": "Uno",
                    "contactDetails": {
                      "telephoneNumber": "string",
                      "email": "User@eXample.com",
                    },
                    "qualifications": qualifications(qualification_type),
                    "searchResultsComparisonPostcode": "SW1A 1AA",
                    "registeredBy": {
                      "schemeId": "472",
                      "name": "ECMK",
                    },
                    "schemeAssessorId": "ECMK9999990",
                  },
                  {
                    "firstName": "Super",
                    "lastName": "James",
                    "contactDetails": {
                      "telephoneNumber": "string",
                      "email": "john@example.com",
                    },
                    "qualifications": qualifications(qualification_type),
                    "searchResultsComparisonPostcode": "SW1A 1AA",
                    "registeredBy": {
                      "schemeId": "332",
                      "name": "Sterling",
                    },
                    "schemeAssessorId": "Sterling999990",
                  },
                  {
                    "firstName": "Supercommon",
                    "lastName": "Twose",
                    "contactDetails": {
                      "telephoneNumber": "07921 021 368",
                      "email": "user@example.com",
                    },
                    "qualifications": qualifications(qualification_type),
                    "searchResultsComparisonPostcode": "SW1A 1AA",
                    "registeredBy": {
                      "schemeId": "432",
                      "name": "EPB 4 U",
                    },
                    "schemeAssessorId": "epb4u12349876",
                  },
                  {
                    "firstName": "Jon",
                    "lastName": "Supercommon",
                    "contactDetails": {
                      "telephoneNumber": "string",
                      "email": "user@example.com",
                    },
                    "qualifications": qualifications(qualification_type),
                    "searchResultsComparisonPostcode": "SW1A 1AA",
                    "registeredBy": {
                      "schemeId": "432",
                      "name": "Quidos",
                    },
                    "schemeAssessorId": "Quidos12349876",
                  },
                  {
                    "firstName": "Mark",
                    "lastName": "Supercommon",
                    "contactDetails": {
                      "telephoneNumber": "string",
                      "email": "mark@example.com",
                    },
                    "qualifications": qualifications(qualification_type),
                    "searchResultsComparisonPostcode": "SW1A 1AA",
                    "registeredBy": {
                      "schemeId": "1222",
                      "name": "Elmhurst Energy",
                    },
                    "schemeAssessorId": "Elmhurst12349876",
                  },
                  {
                    "firstName": "Nocontact",
                    "lastName": "Supercommon",
                    "contactDetails": {},
                    "searchResultsComparisonPostcode": "SW1A 1AA",
                    "registeredBy": {
                      "schemeId": "1222",
                      "name": "Elmhurst Energy",
                    },
                    "qualifications": qualifications(qualification_type),
                    "schemeAssessorId": "Elmhurst12349876",
                  },
                ],
              },
              "meta": {
                "searchName": name,
                "looseMatch": loose_match,
              },
            }.to_json,
          )
      end

      def self.qualifications(type)
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
            "gda": "ACTIVE",
          }
        end
      end
    end
  end
end

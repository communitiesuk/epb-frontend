# frozen_string_literal: true

module UseCase
  class FilterLatestCertificates < UseCase::Base
    def execute(certificates)
      filtered_certificates = {}

      certificates[:data][:assessments].each do |certificate|
        address_id =
          if certificate[:addressId].nil?
            "RRN-" + certificate[:assessmentId]
          else
            certificate[:addressId]
          end.to_sym

        unless filtered_certificates.key?(address_id)
          filtered_certificates[address_id] = {
            addressLine1: certificate[:addressLine1],
            addressLine2: certificate[:addressLine2],
            addressLine3: certificate[:addressLine3],
            addressLine4: certificate[:addressLine4],
            postcode: certificate[:postcode],
            town: certificate[:town],
            certificates: [],
          }
        end

        has_newer = false
        filtered_certificates[address_id][:certificates].each do |other_cert|
          if other_cert[:typeOfAssessment] == certificate[:typeOfAssessment]
            if Date.parse(other_cert[:dateOfExpiry]) <
                Date.parse(certificate[:dateOfExpiry])
              filtered_certificates[address_id][:certificates].delete(
                other_cert,
              )
            elsif Date.parse(other_cert[:dateOfExpiry]) ==
                Date.parse(certificate[:dateOfExpiry])
              if Date.parse(other_cert[:dateOfAssessment]) < Date.parse(certificate[:dateOfAssessment])
                filtered_certificates[address_id][:certificates].delete(
                  other_cert,
                )
              end
            else
              has_newer = true
            end
          end
        end

        unless has_newer
          filtered_certificates[address_id][:certificates].push(certificate)
        end
      end

      filtered_certificates
    end
  end
end

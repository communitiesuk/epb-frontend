# frozen_string_literal: true

module UseCase
  class FilterLatestCertificates < UseCase::Base
    def execute(certificates)
      latest_certs_by_address = {}

      certificates[:data][:assessments].each do |certificate|
        address_id = get_nullable_address_id(certificate)

        unless latest_certs_by_address.key?(address_id)
          create_address(latest_certs_by_address, address_id)
        end

        address_certificates =
          latest_certs_by_address[address_id][:certificates]
        push_if_newer(address_certificates, certificate)
      end

      update_address_lines(latest_certs_by_address)
      latest_certs_by_address
    end

  private

    def update_address_lines(certs_by_address)
      certs_by_address.each_value do |address|
        recent_certificate = nil
        address[:certificates].each do |certificate|
          if recent_certificate.nil? ||
              newer_certificate?(recent_certificate, certificate)
            recent_certificate = certificate
          end
        end

        next if recent_certificate.nil?

        address[:addressLine1] = recent_certificate[:addressLine1]
        address[:addressLine2] = recent_certificate[:addressLine2]
        address[:addressLine3] = recent_certificate[:addressLine3]
        address[:addressLine4] = recent_certificate[:addressLine4]
        address[:town] = recent_certificate[:town]
        address[:postcode] = recent_certificate[:postcode]
      end
    end

    def push_if_newer(address_certificates, certificate)
      found_matching_type = false
      address_certificates.each do |prev_certificate|
        if !(
             Helpers.domestic_certificate_type? certificate[
                                                                            :typeOfAssessment
                                                                          ]
           ) && !same_assessment_type?(prev_certificate, certificate)
          next
        end

        found_matching_type = true
        if newer_certificate?(prev_certificate, certificate)
          address_certificates.delete(prev_certificate)
          address_certificates.push(certificate)
        end
      end

      address_certificates.push(certificate) unless found_matching_type
    end

    def same_assessment_type?(previous_certificate, certificate)
      previous_certificate[:typeOfAssessment] == certificate[:typeOfAssessment]
    end

    def newer_certificate?(prev_certificate, certificate)
      newer_assessment?(prev_certificate, certificate) or
        same_assessment_later_registration?(prev_certificate, certificate)
    end

    def newer_assessment?(prev_certificate, certificate)
      unless Date.parse(prev_certificate[:dateOfRegistration]) == Date.parse(certificate[:dateOfRegistration])
        return Date.parse(prev_certificate[:dateOfRegistration]) <
            Date.parse(certificate[:dateOfRegistration])
      end

      if both_created_at_present?(prev_certificate, certificate)
        return Time.parse(prev_certificate[:createdAt]) <
            Time.parse(certificate[:createdAt])
      end

      Date.parse(prev_certificate[:dateOfAssessment]) < Date.parse(certificate[:dateOfAssessment])
    end

    def same_assessment_later_registration?(prev_certificate, certificate)
      Date.parse(prev_certificate[:dateOfAssessment]) ==
        Date.parse(certificate[:dateOfAssessment]) and
        Date.parse(prev_certificate[:dateOfRegistration]) <
          Date.parse(certificate[:dateOfRegistration])
    end

    def create_address(latest_certs, address_id)
      latest_certs[address_id] = {
        addressLine1: nil,
        addressLine2: nil,
        addressLine3: nil,
        addressLine4: nil,
        postcode: nil,
        town: nil,
        certificates: [],
      }
    end

    def get_nullable_address_id(certificate)
      if certificate[:addressId].nil?
        "RRN-#{certificate[:assessmentId]}"
      else
        certificate[:addressId]
      end.to_sym
    end

    def both_created_at_present?(prev_certificate, certificate)
      !(prev_certificate[:createdAt].nil? || prev_certificate[:createdAt].empty?) &&
        !(certificate[:createdAt].nil? || certificate[:createdAt].empty?)
    end
  end
end

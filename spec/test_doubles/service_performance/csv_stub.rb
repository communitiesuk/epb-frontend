module ServicePerformance
  class CsvStub
    def self.all_regions
      <<~CSV
              Month,SAPs Lodged,Average SAP Energy Rating,Average SAP CO2/sqm emissions,RdSAPs Lodged,Average RdSAP Energy Rating,Average RdSAP CO2/sqm emissions,CEPCs Lodged,Average CEPC Energy Rating,DECs Lodged,DEC-RRs Lodged,AC-CERTs Lodged
        Oct-2021,21163,78.41,,122394,61.71,,8208,67.36,2189,470,1251
        Sep-2021,24477,77.83,16,121499,61.71,10,7718,68.27,3500,428,918
      CSV
    end

    def self.england
      <<~CSV
        Month,SAPs Lodged,Average SAP Energy Rating,Average SAP CO2/sqm emissions,RdSAPs Lodged,Average RdSAP Energy Rating,Average RdSAP CO2/sqm emissions,CEPCs Lodged,Average CEPC Energy Rating,DECs Lodged,DEC-RRs Lodged,AC-CERTs Lodged
        Oct-2021,20489,78.4,,120045,61.73,,8074,67.33,2781,462,1206
        Sep-2021,23834,77.82,15,119033,61.74,10,7572,68.18,3298,402,861
      CSV
    end

    def self.northern_ireland
      <<~CSV
              Month,SAPs Lodged,Average SAP Energy Rating,Average SAP CO2/sqm emissions,RdSAPs Lodged,Average RdSAP Energy Rating,Average RdSAP CO2/sqm emissions,CEPCs Lodged,Average CEPC Energy Rating,DECs Lodged,DEC-RRs Lodged,AC-CERTs Lodged
        Oct-2021,674,81.7,,2349,61.11,,134,90.5,38,8,45
        Sep-2021,643,82.56,,2466,58.59,,146,79.33,202,26,57
      CSV
    end

    def self.other
      <<~CSV
        Month,SAPs Lodged,Average SAP Energy Rating,RdSAPs Lodged,Average RdSAP Energy Rating,CEPCs Lodged,Average CEPC Energy Rating,DECs Lodged,DEC-RRs Lodged,AC-CERTs Lodged
        Oct-2021,21163,78.41,122394,61.71,8208,67.36,2189,470,1251
        Sep-2021,24477,77.83,121499,61.71,7718,68.27,3500,428,918
      CSV
    end
  end
end

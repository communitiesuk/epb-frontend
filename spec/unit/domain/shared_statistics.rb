shared_examples "Domain::Statistics" do
  def england
    [{ "Month" => "Oct-2021",
       "SAPs Lodged" => 20_489,
       "Average SAP Energy Rating" => 78.40,
       "Average SAP CO2/sqm emissions" => nil,
       "RdSAPs Lodged" => 120_045,
       "Average RdSAP Energy Rating" => 61.73,
       "Average RdSAP CO2/sqm emissions" => nil,
       "CEPCs Lodged" => 8074,
       "Average CEPC Energy Rating" => 67.33,
       "DECs Lodged" => 2781,
       "DEC-RRs Lodged" => 462,
       "AC-CERTs Lodged" => 1206 },
     { "Month" => "Sep-2021",
       "SAPs Lodged" => 23_834,
       "Average SAP Energy Rating" => 77.82,
       "Average SAP CO2/sqm emissions" => 15.74,
       "RdSAPs Lodged" => 119_033,
       "Average RdSAP Energy Rating" => 61.74,
       "Average RdSAP CO2/sqm emissions" => 10.88,
       "CEPCs Lodged" => 7572,
       "Average CEPC Energy Rating" => 68.18,
       "DECs Lodged" => 3298,
       "DEC-RRs Lodged" => 402,
       "AC-CERTs Lodged" => 861 }]
  end

  def northern_ireland
    [{ "Month" => "Oct-2021",
       "SAPs Lodged" => 674,
       "Average SAP Energy Rating" => 81.70,
       "Average SAP CO2/sqm emissions" => nil,
       "RdSAPs Lodged" => 2349,
       "Average RdSAP Energy Rating" => 61.11,
       "Average RdSAP CO2/sqm emissions" => nil,
       "CEPCs Lodged" => 134,
       "Average CEPC Energy Rating" => 90.5,
       "DECs Lodged" => 38,
       "DEC-RRs Lodged" => 8,
       "AC-CERTs Lodged" => 45 },
     { "Month" => "Sep-2021",
       "SAPs Lodged" => 643,
       "Average SAP Energy Rating" => 82.56,
       "Average SAP CO2/sqm emissions" => nil,
       "RdSAPs Lodged" => 2466,
       "Average RdSAP Energy Rating" => 58.59,
       "Average RdSAP CO2/sqm emissions" => nil,
       "CEPCs Lodged" => 146,
       "Average CEPC Energy Rating" => 79.33,
       "DECs Lodged" => 202,
       "DEC-RRs Lodged" => 26,
       "AC-CERTs Lodged" => 57 }]
  end

  def all_countries
    [{ "Month" => "Oct-2021",
       "SAPs Lodged" => 21_163,
       "Average SAP Energy Rating" => 78.41,
       "Average SAP CO2/sqm emissions" => nil,
       "RdSAPs Lodged" => 122_394,
       "Average RdSAP Energy Rating" => 61.71,
       "Average RdSAP CO2/sqm emissions" => nil,
       "CEPCs Lodged" => 8208,
       "Average CEPC Energy Rating" => 67.36,
       "DECs Lodged" => 2189,
       "DEC-RRs Lodged" => 470,
       "AC-CERTs Lodged" => 1251 },
     { "Month" => "Sep-2021",
       "SAPs Lodged" => 24_477,
       "Average SAP Energy Rating" => 77.83,
       "Average SAP CO2/sqm emissions" => 16.24,
       "RdSAPs Lodged" => 121_499,
       "Average RdSAP Energy Rating" => 61.71,
       "Average RdSAP CO2/sqm emissions" => 10.88,
       "CEPCs Lodged" => 7718,
       "Average CEPC Energy Rating" => 68.27,
       "DECs Lodged" => 3500,
       "DEC-RRs Lodged" => 428,
       "AC-CERTs Lodged" => 918 }]
  end
end

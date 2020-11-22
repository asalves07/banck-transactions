shared_examples "number searchable concern" do |factory_number|
  let!(:search_params) {"1234567"}
  let!(:record_to_find) {create(factory_number, number: "1234567")}
  let!(:records_to_ignore) { create_list(factory_number, 3 )}

  it "Found records with expression in :number" do
    found_records = described_class.search_by_number(search_params)
    expect(found_records.to_a).to contain_exactly(*record_to_find)
  end

  it "ignores records without expression in :number" do
    found_records = described_class.search_by_number(search_params)
    expect(found_records.to_a).to_not include(*records_to_ignore)
  end
end
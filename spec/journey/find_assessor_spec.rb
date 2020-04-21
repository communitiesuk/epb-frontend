describe 'Journey::FindAssessor', type: :feature, journey: true do
  before(:all) do
    process =
      IO.popen(
        ['rackup', 'config_test.ru', '-q', '-o', '127.0.0.1', '-p', '9393', err: %i[child out]]
      )
    @process_id = process.pid

    unless process.readline.include?('port=9393')
    end
  end

  after(:all) { Process.kill('KILL', @process_id) }

  it 'finds an assessor by postcode' do
    visit "/find-an-assessor"
    click_on "Start now"
    fill_in 'postcode', with: 'SW1A 2AA'
    click_on 'Find'
  end

  it 'finds an assessor by postcode in Welsh' do
    visit "/find-an-assessor"
    click_on 'Welsh (Cymraeg)'
    click_on 'Welsh: Start now'
    fill_in 'postcode', with: 'SW1A 2AA'
    click_on 'Welsh: Find'
  end

  it 'displays an error message when entering an empty postcode' do
    visit "/find-an-assessor"
    click_on "Start now"
    fill_in 'postcode', with: ''
    click_on 'Find'
    expect(page).to have_content 'Enter a real postcode'
  end

  it 'displays an error message when entering an invalid postcode' do
    visit "/find-an-assessor"
    click_on "Start now"
    fill_in 'postcode', with: 'NOT A POSTCODE'
    click_on 'Find'
    expect(page).to have_content 'Enter a real postcode'
  end

  it 'displays the find an assessor page heading when entering a valid postcode ' do
    visit "/find-an-assessor"
    click_on "Start now"
    fill_in 'postcode', with: 'SW1A 2AA'
    click_on 'Find'
    expect(page).to have_content '3 assessors, sorted by distance from SW1A 2AA'
  end

  it 'displays an error message when entering an empty name' do
    visit "/find-an-assessor"
    click_on "Start now"
    click_on 'Find assessor by name'
    click_on 'Search'
    expect(page).to have_content 'Enter a name'
  end

  it 'displays an assessor when searched for one that does exist' do
    visit "/find-an-assessor"
    click_on "Start now"
    click_on 'Find assessor by name'
    fill_in 'name', with: 'Supercommon Name'
    click_on 'Search'
    expect(page).to have_content '3 results, found by the name Supercommon Name'
  end


  describe 'given finding a non-domestic assessor by postcode' do
    it 'finds a non-domestic assessor by postcode' do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor service"
      fill_in 'postcode', with: 'SW1A 2AA'
      click_on 'Find'
    end

    it 'displays an error message when entering an empty postcode' do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor service"
      fill_in 'postcode', with: ''
      click_on 'Find'
      expect(page).to have_content 'Enter a real postcode'
    end

    it 'displays an error message when entering an invalid postcode' do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor service"
      fill_in 'postcode', with: 'NOT A POSTCODE'
      click_on 'Find'
      expect(page).to have_content 'Enter a real postcode'
    end

    it 'displays the find a non domestic assessor page heading when entering a valid postcode ' do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor service"
      fill_in 'postcode', with: 'SW1A 2AA'
      click_on 'Find'
      expect(page).to have_content '3 assessors, sorted by distance from SW1A 2AA'
    end 
  end
end

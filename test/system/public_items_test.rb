require "application_system_test_case"

class PublicItemsTest < ApplicationSystemTestCase
  setup do
    Item.delete_all
    borrow_policy = create(:borrow_policy)

    items = [3, 6, 1].each_with_index.map { |age, i|
      create(:item,
        name: "Item ##{3 - i}",
        description: "The description for item ##{3 - i}",
        borrow_policy: borrow_policy,
        created_at: age.days.ago)
    }

    tag = create(:tag, name: "Big")
    items.first.tap { |i| i.tags << tag }
  end

  test "creating an item" do
    visit items_url

    within ".items-table .items-table-name", text: "Item #1" do
      click_on "Item #1"
    end

    assert_content "Item #1"
    assert_content "The description for item #1"
  end

  test "sorting items" do
    visit items_url

    assert_item_names "Item #1", "Item #2", "Item #3"

    click_on "number"

    assert_item_names "Item #3", "Item #2", "Item #1"

    click_on "added"

    assert_item_names "Item #1", "Item #3", "Item #2"
  end

  test "search by name" do
    visit items_url

    fill_in "query", with: "#2"
    click_on "Search"

    assert_content "Viewing 1 item"
    assert_item_names "Item #2"

    find(".items-summary .btn-clear").click

    assert_item_names "Item #1", "Item #2", "Item #3"
  end

  test "view items page" do
    item = Item.first

    visit item_url(item)

    assert_selector "h1", text: item.name
    assert_content item.number
  end

  test "filter by tag" do
    visit items_url

    within ".tag-nav" do
      click_on "Big"
    end

    assert_item_names "Item #3"
  end

  private def assert_item_names(*expected_names)
    # wait for the first expected item to be first
    find ".items-table .items-table-name:nth-of-type(2) a", text: expected_names.first
  rescue Capybara::ElementNotFound
    # no op
  ensure
    names = all(".items-table .items-table-name a").map { |el| el.text }
    assert_equal expected_names, names
  end
end
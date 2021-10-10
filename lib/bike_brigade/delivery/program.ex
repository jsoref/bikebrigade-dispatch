defmodule BikeBrigade.Delivery.Program do
  use BikeBrigade.Schema
  import Ecto.Changeset
  import EctoEnum
  import Crontab.CronExpression

  alias BikeBrigade.Delivery.{Item, Campaign}

  defenum(SpreadsheetLayout,
    foodshare: "foodshare",
    map: "map"
  )

  defmodule Schedule do
    use BikeBrigade.Schema

    embedded_schema do
      field :cron, Ecto.Cron, default: ~e[0 12 * * 3 *]
      field :duration, :integer, default: 60
    end

    def changeset(schedule, attrs \\ %{}) do
      schedule
      |> cast(attrs, [:cron, :duration])
      |> validate_required([:cron, :duration])
    end
  end

  schema "programs" do
    field :name, :string
    field :contact_name, :string
    field :contact_email, :string
    field :contact_phone, BikeBrigade.EctoPhoneNumber.Canadian
    field :campaign_blurb, :string
    field :description, :string
    field :spreadsheet_layout, SpreadsheetLayout, default: :foodshare
    field :active, :boolean, default: true
    field :start_date, :date
    embeds_many :schedules, Schedule, on_replace: :delete

    field :campaign_count, :integer, virtual: true
    field :latest_campaign_id, :integer, virtual: true
    belongs_to :latest_campaign, Campaign, define_field: false

    belongs_to :lead, BikeBrigade.Accounts.User, on_replace: :nilify
    has_many :campaigns, Campaign
    has_many :items, Item
    belongs_to :default_item, Campaign

    timestamps()
  end

  @doc false
  def changeset(program, attrs) do
    program
    |> cast(attrs, [
      :name,
      :contact_name,
      :contact_email,
      :contact_phone,
      :campaign_blurb,
      :description,
      :lead_id,
      :spreadsheet_layout,
      :start_date,
      :active,
      :default_item_id
    ])
    |> validate_required([:name, :start_date])
    |> foreign_key_constraint(:lead_id)
    |> cast_embed(:schedules)
  end
end

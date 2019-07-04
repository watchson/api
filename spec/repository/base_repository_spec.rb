require_relative '../../app/repository/base_repository'

describe BaseRepository, "BaseRepository" do
  context "execute action" do
    before(:each) do
      @dynamo_db = double(:put_item => nil)
      @base_repository = BaseRepository.send :new, @dynamo_db
      @base_repository.define_singleton_method(:table_name) do
        "BatataTable"
      end
    end

    it "save" do
      @base_repository.save({ user_id: "batata" })

      expect(@dynamo_db).to have_received(:put_item) do |arg|
        expect(arg[:table_name]).to eq("BatataTable")
        expect(arg[:item][:user_id]).to eq("batata")
      end
    end

    it "find with hashkey" do
      params = {
          table_name: "BatataTable",
          key: {
              "batata" => "frita"
          }
      }
      result = double(:item => { "batata": "frita" })
      allow(@dynamo_db).to receive(:get_item).with(params) { result }

      ret = @base_repository.search_item("batata", "frita")

      expect(ret[:batata]).to eq("frita")
    end

    it "find with hashkey and rangekey" do
      params = {
        table_name: "BatataTable",
        key: {
            "batata" => "frita",
            "sem" => "sal"
        }
      }
      result = double(:item => { "batata": "frita" })
      allow(@dynamo_db).to receive(:get_item).with(params) { result }

      ret = @base_repository.search_item("batata", "frita", "sem", "sal")

      expect(ret[:batata]).to eq("frita")
     end
  end

end
# frozen_string_literal: true

shared_context 'a result that is type cast' do |types|
  types.each do |type, clazz|
    context "with #{type} type" do
      let(:type) { type }

      it do
        expect(cast).to be_a(clazz)
      end
    end
  end
end

shared_context 'casts basic types' do
  it_behaves_like 'a result that is type cast',
                  integer: Integer,
                  float: Float,
                  string: String
end

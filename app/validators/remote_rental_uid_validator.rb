class RemoteRentalUidValidator < ActiveRecord::Validations::UniquenessValidator
  def initialize(options)
    options.merge!(attributes: :uid, allow_nil: true)
    super
  end
end

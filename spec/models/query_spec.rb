require 'spec_helper'

describe Query do

  it { should validate_presence_of(:uid) }
  it { should validate_presence_of(:pub0) }
  it { should validate_numericality_of(:page).only_integer }
  it { should validate_numericality_of(:page).is_greater_than(0) }

end

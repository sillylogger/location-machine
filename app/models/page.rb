class Page < ApplicationRecord

  VISIBILITY = {
    public:    "Public",
    protected: "Protected"
  }

  has_paper_trail

end

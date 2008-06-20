module MonadPlus
  def guard p
    if p
      unit(mzero)
    else
      mzero
    end
  end
end
class Hash
  def keep_keys(keyList)
    self.each_key { |key| delete(key) unless keyList.member? key.to_sym }
  end
end


module CollectionHelpers

  def add_n_files_to_collection(collection, number=15, opts={})
    user_key = opts[:user] ? opts[:user]  : FactoryGirl.build(:user).user_key
    existing_files = GenericFile.where(depositor_tesim: user_key)
    filecount = existing_files.count
    created_files = []
    until filecount >= 15
      gf = GenericFile.new(title: "Test file #{filecount+1}" )
      gf.apply_depositor_metadata(user_key)
      gf.save
      created_files << gf
      filecount += 1
      puts "#{user_key} now owns #{filecount} files. Needs #{number} to add to \"#{collection.title}\" "
    end
    # Add created files to existing files if more files were created
    existing_files = existing_files.to_a
    unless created_files.empty?
      existing_files = existing_files.concat(created_files)
    end
    collection.members = existing_files[0..15]
    collection.save
    existing_files[0..15]
  end
end
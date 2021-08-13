#import the xcodeproj ruby gem
require "xcodeproj"

#define the path to your .xcodeproj file
project_path = "./TableCollectionFeatures.xcodeproj"

#open the xcode project
project = Xcodeproj::Project.open(project_path)

#iterate over groups, remove Fastlane and Environment references
project.groups.each do |group|
    group.recursive_children_groups.each do |childGroup|
        if childGroup.display_name == "Fastlane" || childGroup.display_name == "Environment"
            childGroup.remove_from_project
        end
    end
end

#iterate over files, remove unnecessary files
project.files.each do |file|
    hierPath = file.hierarchy_path
    
    if hierPath == "/TableCollectionFeatures/Info.plist"
        file.remove_from_project
        File.delete("." + hierPath) if File.exist?("." + hierPath)
    end
    
    if hierPath == "/TableCollectionFeatures/Assets.xcassets"
        file.remove_from_project
        FileUtils.rm_rf("./TableCollectionFeatures/Assets.xcassets")
    end
    
end

puts "All unnecessary files and references were removed"
 
# Save the project file
project.save

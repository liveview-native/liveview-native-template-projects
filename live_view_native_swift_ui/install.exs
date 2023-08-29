require Logger

# Get host project install from `mix lvn.install` and setup paths
args = System.argv()
{opts, _, _} = OptionParser.parse(args, strict: [app_name: :string, app_path: :string, platform_lib_path: :string])
app_name = Keyword.get(opts, :app_name) || raise "--app-name not set. Installation failed..."
app_path = Keyword.get(opts, :app_path) || raise "--app-path not set. Installation failed..."
platform_lib_path = Keyword.get(opts, :platform_lib_path) || raise "--platform-lib-path not set. Installation failed..."
app_native_path = Path.join(app_path, "native")
app_native_platform_path = Path.join(app_native_path, "swiftui")

# Create native path if it does not exist
if not File.exists?(app_native_path) do
  File.mkdir(app_native_path)
end

# Create native/swiftui path if it does not exist and copy the template
# project into it, replacing the `LiveViewNativeTemplate` name with the
# name of the project that was passed to this script.
if not File.exists?(app_native_platform_path) do
  template_path = Path.join(platform_lib_path, "LiveViewNativeTemplate")
  dest_path = Path.join(app_native_platform_path, app_name)
  dest_template_target_path = Path.join(dest_path, "LiveViewNativeTemplate")
  dest_target_path = Path.join(dest_path, app_name)
  dest_template_project_path = Path.join(dest_path, "LiveViewNativeTemplate.xcodeproj")
  dest_project_path = Path.join(dest_path, app_name <> ".xcodeproj")
  dest_template_app_file_path = Path.join(dest_target_path, "LiveViewNativeTemplateApp.swift")
  dest_app_file_path = Path.join(dest_target_path, app_name <> "App.swift")
  project_file_path = Path.join(dest_project_path, "project.pbxproj")

  File.mkdir(app_native_platform_path)
  File.cp_r(template_path, dest_path)

  File.rename(dest_template_target_path, dest_target_path)
  File.rename(dest_template_project_path, dest_project_path)
  File.rename(dest_template_app_file_path, dest_app_file_path)

  {:ok, project_file_body} = File.read(project_file_path)
  {:ok, project_file} = File.open(project_file_path, [:write])
  updated_project_file_body = String.replace(project_file_body, "LiveViewNativeTemplate", app_name)
  IO.binwrite(project_file, updated_project_file_body)
  File.close(project_file)

  {:ok, app_file_body} = File.read(dest_app_file_path)
  {:ok, app_file} = File.open(dest_app_file_path, [:write])
  updated_app_file_body = String.replace(app_file_body, "LiveViewNativeTemplate", app_name)
  IO.binwrite(app_file, updated_app_file_body)
  File.close(app_file)
end

# Return namespace
IO.puts "LiveViewNativeSwiftUi"

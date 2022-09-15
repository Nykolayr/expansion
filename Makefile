clean:
	@echo "Cleaning the project"
	@flutter clean

format:
	@echo "Formatting the code"
	@dart fix --apply .
	@dart format -l 80 --fix .

get:
	@echo "Geting dependencies"
	@flutter pub get

upgrade: get
	@echo "Upgrading dependencies"
	@flutter pub upgrade

upgrade-major: get
	@echo "Upgrading dependencies --major-versions"
	@flutter pub upgrade --major-versions

codegen: get
	@echo "Running codegeneration"
	@flutter pub run build_runner build --delete-conflicting-outputs --release

cleancodegen: 
	@flutter pub run build_runner clean

newcodegen: cleancodegen
	@echo "Running codegeneration"
	@flutter pub run build_runner build --delete-conflicting-outputs --release

outdated:
	@flutter pub outdated

versia2: 
	@echo "запуск флаттера версии 2.2.3"
	@export PATH="$PATH:/Users/ryzhovnikolay/Documents/flutters/flutter2.2.3/bin"

repoupdate:
	@arch -x86_64 pod install --repo-update

versia25: 
	@echo "запуск флаттера версии 2.5"
	@export PATH="$PATH:/Users/ryzhovnikolay/Documents/flutters/flutter2.5/bin"

versia28: 
	@echo "запуск флаттера версии 2.8"
	@PATH="$PATH:/Users/ryzhovnikolay/Documents/flutters/flutter2.8.1/bin"

newversia:
	@export PATH="$PATH:/Users/ryzhovnikolay/Documents/flutters/flutter3.0.2/bin"

doctor:
	@flutter doctor -v

release:
	@flutter build apk --release

deintegrate:
	@pod deintegrate 
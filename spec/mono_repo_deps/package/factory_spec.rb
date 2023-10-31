RSpec.describe MonoRepoDeps::Package::Factory do
  let(:block) {
    Proc.new do
      package do
        name 'package_0'
      end

      dependency do
        import 'package_1'
        import 'package_2', only: [:package_2_1]
        import 'package_3', skip: [:package_3_1]
      end

      dependency :test do
        import 'package_4'
      end
    end
  }

  it "sets up project" do
    package = subject.call('example_dir', 'package', init_proc: block)

    expect(package.name).to eq(:package_0)
    expect(package.dependencies).to match({
      _default_: [
        MonoRepoDeps::Package::DependencyDto.new(name: :package_1, only: nil, skip: nil),
        MonoRepoDeps::Package::DependencyDto.new(name: :package_2, only: [:package_2_1], skip: nil),
        MonoRepoDeps::Package::DependencyDto.new(name: :package_3, only: nil, skip: [:package_3_1])
      ],
      test: [
        MonoRepoDeps::Package::DependencyDto.new(name: :package_4, only: nil, skip: nil)
      ]
    })
  end
end
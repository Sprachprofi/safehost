# Core extensions
Dir[File.join(Rails.root, 'lib', 'core_ext', '*.rb')].each { |l| require l }

# Other extensions
#Dir[File.join(Rails.root, 'lib', 'other_ext', '*.rb')].each { |l| require l }

# Notifiers
#Dir[File.join(Rails.root, 'lib', 'notifiers', '*.rb')].each { |l| require l }

# API Integrations
Dir[File.join(Rails.root, 'lib', 'integrations', '*.rb')].sort.each { |l| require l }


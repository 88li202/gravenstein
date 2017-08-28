namespace :survey do
  desc 'Denormalize all closed surveys not yet denormalized'
  # cf. the instance method named +denormalize+ in the Survey class
  # Final goal is to keep only the survey main outputs (stats/trends, ...) saved in a result record.
  # and to cleanup the database (removing the answers records, useless at this point).
  task :denormalize => :environment do
    puts(Survey.denormalize_all ? I18n.t('result.denormalized_successfully') : I18n.t('result.denormalized_with_errors'))
  end
end

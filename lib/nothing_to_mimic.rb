class NothingToMimic < Exception
  def initialize
    super <<MESSAGE
You aren't using Mimic correctly.  Call Mimic.make_a_mimic_of(to_mimic, subject)
passing the object to mimic as to_mimic and the target of the mimic invocation as
subject.  Shazaaam!
MESSAGE
  end
end
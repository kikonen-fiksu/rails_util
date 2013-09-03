rails_util
==========

Misc small rails utilities

Currently approach is "all or nothing"


@see http://opensoul.org/blog/archives/2012/05/30/releasing-multiple-gems-from-one-repository/


INSTALL
=======

1) Create file

config/initializers/rails_util.rb
```
# query tracer
if Settings.sql && Settings.sql.trace
  QueryTracer.start!
end

# ruby_prof_helper
# USAGE:
#   Profiler.profile 'name' { block }

# log_helper
# USAGE:
#   Log.ndc :name { block }
#   Log.backtrace
Log.init
```

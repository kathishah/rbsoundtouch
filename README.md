Notes
=====

1. install alsa: sudo apt-get install alsa-base
2. install soundtouch/soundstretch: sudo apt-get install libsoundtouch-dev soundstretch
3. get soundtouch source: wget "http://www.surina.net/soundtouch/soundtouch-1.7.0.tar.gz"
4. install rvm: curl -L https://get.rvm.io | bash -s stable --ruby
5. get other dependencies:
5.1 $ rvm requirements => will list other dependencies
5.2 $ sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config
5.3 gem install ZenTest hoe rake-compiler (http://tenderlovemaking.com/2009/12/18/writing-ruby-c-extensions-part-1.html)
6. sudo apt-get install swig
7. create a soundtouch.i file (see attached)
8. run swig to create the cxx wrapper: swig -c++ -ruby soundtouch.i 
9. create extconf.rb to define a new extension: 
	require 'mkmf'
	dir_config('soundtouch')
	have_library('SoundTouch')
	create_makefile('soundtouch')
	ruby extconf.rb --with-soundtouch-dir=/usr/lib/x86_64-linux-gnu --with-soundtouch-include=/usr/include/soundtouch
	edit Makefile
	V = 1 # turn on verbose
	//search for linux and change /usr/lib/x86_64-linux-gnu/lib or /usr/lib/x86_64-linux-gnu/include to /usr/lib/x86_64-linux-gnu
	//change /usr/include/soundtouch/lib or /usr/include/soundtouch/include to /usr/include/soundtouch
10. make => soundtouch.so will be created
	g++ -shared -o soundtouch.so soundtouch_wrap.o -L. -L/home/chintan/.rvm/rubies/ruby-1.9.3-p327/lib -Wl,-R/home/chintan/.rvm/rubies/ruby-1.9.3-p327/lib -L/usr/lib/x86_64-linux-gnu -Wl,-R/usr/lib/x86_64-linux-gnu -L/home/chintan/.rvm/usr/lib -Wl,-R/home/chintan/.rvm/usr/lib -L.  -rdynamic -Wl,-export-dynamic -L/home/chintan/.rvm/usr/lib  -Wl,-R/home/chintan/.rvm/usr/lib  -L/home/chintan/.rvm/usr/lib  -Wl,-R/home/chintan/.rvm/usr/lib    -Wl,-R -Wl,/home/chintan/.rvm/rubies/ruby-1.9.3-p327/lib -L/home/chintan/.rvm/rubies/ruby-1.9.3-p327/lib -lruby -lSoundTouch  -lpthread -lrt -ldl -lcrypt -lm   -lc
11. make install => soundtouch.so will be installed in the rvm path
	/bin/mkdir -p /home/chintan/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/site_ruby/1.9.1/x86_64-linux
	/usr/bin/install -c -m 0755 soundtouch.so /home/chintan/.rvm/rubies/ruby-1.9.3-p327/lib/ruby/site_ruby/1.9.1/x86_64-linux
12. test if soundtouch can be used:
	$ irb
	1.9.2-p320 :001 > require 'soundtouch'
	 => true
	1.9.3-p327 :003 > Soundtouch::SoundTouch.getVersionString
	 => "1.6.0"
	1.9.3-p327 :002 > Soundtouch::SoundTouch.getVersionId
	 => 10600


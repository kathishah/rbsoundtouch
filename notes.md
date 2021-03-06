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
5.4 gem install wav-file (https://github.com/shokai/ruby-wav-file)
5.4 cp irbrc ~/.irbrc
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
	ubuntu~/dev/rbsoundtouch> make
	g++ -I. -I/home/chintan/.rvm/rubies/ruby-1.9.3-p327/include/ruby-1.9.1/x86_64-linux -I/home/chintan/.rvm/rubies/ruby-1.9.3-p327/include/ruby-1.9.1/ruby/backward -I/home/chintan/.rvm/rubies/ruby-1.9.3-p327/include/ruby-1.9.1 -I. -I/usr/include/soundtouch -I/usr/lib/x86_64-linux-gnu/include    -I/home/chintan/.rvm/usr/include -fPIC -O3 -ggdb -Wall -Wextra -Wno-unused-parameter -Wno-parentheses -Wno-long-long -Wno-missing-field-initializers -Wpointer-arith -Wwrite-strings -Wdeclaration-after-statement -Wimplicit-function-declaration  -fPIC   -o soundtouch_wrap.o -c soundtouch_wrap.cxx
	cc1plus: warning: command line option ‘-Wdeclaration-after-statement’ is valid for C/ObjC but not for C++ [enabled by default]
	cc1plus: warning: command line option ‘-Wimplicit-function-declaration’ is valid for C/ObjC but not for C++ [enabled by default]
	soundtouch_wrap.cxx: In function ‘void SWIG_Ruby_define_class(swig_type_info*)’:
	soundtouch_wrap.cxx:1517:9: warning: variable ‘klass’ set but not used [-Wunused-but-set-variable]
	soundtouch_wrap.cxx: In function ‘VALUE SWIG_AUX_NUM2DBL(VALUE*)’:
	soundtouch_wrap.cxx:2075:9: warning: unused variable ‘type’ [-Wunused-variable]
	rm -f soundtouch.so
	g++ -shared -o soundtouch.so soundtouch_wrap.o -L. -L/home/chintan/.rvm/rubies/ruby-1.9.3-p327/lib -Wl,-R/home/chintan/.rvm/rubies/ruby-1.9.3-p327/lib -L/usr/lib/x86_64-linux-gnu/lib -Wl,-R/usr/lib/x86_64-linux-gnu/lib -L/home/chintan/.rvm/usr/lib -Wl,-R/home/chintan/.rvm/usr/lib -L.  -rdynamic -Wl,-export-dynamic -L/home/chintan/.rvm/usr/lib  -Wl,-R/home/chintan/.rvm/usr/lib  -L/home/chintan/.rvm/usr/lib  -Wl,-R/home/chintan/.rvm/usr/lib    -Wl,-R -Wl,/home/chintan/.rvm/rubies/ruby-1.9.3-p327/lib -L/home/chintan/.rvm/rubies/ruby-1.9.3-p327/lib -lruby -lSoundTouch  -lpthread -lrt -ldl -lcrypt -lm   -lc
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
13. irb > f = open("/home/chintan/downloads/test01.wav")
	irb > fmt, chunks = WavFile::readFormat(f);nil #=> no output
	irb > buf = chunks[0].data.slice(0,4096)
	irb > float_buf = buf.unpack('f1024') # If I try with 2048, I get 1024 nils
	irb > s.putSamples(float_buf, 2048/2)
	TypeError: Expected argument 1 of type soundtouch::SAMPLETYPE const *, but got Array [0.0, 0.0, 0.0, 0.0, 0.0, 0.0,...
		in SWIG method 'putSamples'
		from (irb):52:in `putSamples'
		from (irb):52
		from /home/chintan/.rvm/rubies/ruby-1.9.3-p327/bin/irb:16:in `<main>'

Reference
---------
1. http://stuff.mit.edu/afs/athena/astaff/project/svn/src/swig-1.3.25/Lib/ruby/rubyswigtype.swg
1. http://www.opensource.apple.com/source/swig/swig-4/swig/Lib/ruby/typemaps.i?txt
1. http://www.ibm.com/developerworks/aix/library/au-swig/au-swig-pdf.pdf (locally saved)
1. http://www.swig.org/Doc1.3/Typemaps.html#Typemaps_nn2
1. http://www.goto.info.waseda.ac.jp/~fukusima/ruby/swig-examples/pointer/example.i
1. http://github.com/kathishah/ruby-wav-file 
1. http://www.swig.org/Doc1.3/Ruby.html


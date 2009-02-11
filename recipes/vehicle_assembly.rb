prefix = "#{File.dirname(__FILE__)}/../"
rails_root = "#{prefix}/../../../"
require "#{prefix}/lib/vehicle_assembly"

before "bootstrap:cold", "bootstrap:update_cache"
after "deploy", "webapp:gems"
after "deploy", "webapp:set_ownership"

namespace :mission_control do
  
  task :launch do
    vab = VehicleAssembly::Configuration.start_countdown_for "config/cloud.rb"
    vab.vehicle.machines.each do |machine|
    unless machine.task.nil?
      self.desc "Task defined in #{machine.class.to_s}"      
      self.send :task, machine.task_name, &machine.task
      # run "#{machine.task_name}"
    end
    end
  end
  
end

namespace :bootstrap do

  desc "Bootstraps a cold instance"
  task :cold do
    ubuntu
    apache
    gems
    capistrano
    git
    svn
    webapp
    passenger
    mysql
    sqlite
    rcov
    ssl
  end

  task :ubuntu do
    run "apt-get install ruby1.8-dev -y"
    run "apt-get install gcc -y"
    run "apt-get install build-essential -y"
    run "ldconfig /usr/local/lib"
  end
  
  desc "Bootstraps Apache 2"
  task :apache do
    run "apt-get install apache2 -y"
    run "apt-get install apache2-prefork-dev -y"
  end
  
  desc "Bootstraps Rubygems (including Passenger and Rails)"
  task :gems do
    run "apt-get install rubygems -y"
    run "gem update"
    run "gem update --system"
    put File.read("#{prefix}/lib/deploy/gem.rb"), "/usr/bin/gem"
    run "gem install passenger --no-ri --no-rdoc"
    run "gem install rails --no-ri --no-rdoc"    
  end

  desc "Bootstraps Git"
  task :git do
    run "apt-get install git-core -y"
  end

  desc "Bootstraps SVN"
  task :svn do
    run "apt-get install subversion -y"
  end
    
  desc "Bootstraps the web app environment"
  task :webapp do
    run "mkdir /var/rails" 
  end
  
  desc "Bootstraps Apache 2 with Passenger"
  task :passenger do
    run "cd #{passenger_root}; rake clean apache2"
    template = ERB.new File.read("#{prefix}/lib/deploy/templates/passenger.erb")
    prepared = template.result(binding)
    put prepared, "/etc/apache2/passenger.conf"
    run "cat /etc/apache2/passenger.conf >> /etc/apache2/apache2.conf"
    run "rm /etc/apache2/passenger.conf"
    run "/etc/init.d/apache2 restart"
    run "ldconfig /usr/local/lib"
  end
  
  desc "Bootstraps MySQL"
  task :mysql do 
    run "export DEBIAN_FRONTEND=noninteractive; apt-get -y install mysql-server"
    run "apt-get install libmysqlclient15-dev -y"
    run "gem install mysql -- --with-mysql-dir=/usr/include/mysql"
  end
  
  task :library do
    run "ldconfig /usr/local/lib"
  end
  
  task :sqlite do
    run "gem install sqlite3-ruby"
  end
  
  task :update_cache do
    run "apt-get update"
  end
    
  task :rails do
    run "gem install rails"
  end
  
  task :rcov do
    run "gem install rcov"
  end

  task :capistrano do
    run "gem install capistrano"
  end

  task :rmagick do
    run "apt-get build-dep imagemagick -y"
    run "apt-get install gcc libjpeg62-dev libbz2-dev libtiff4-dev libwmf-dev libz-dev libpng12-dev libx11-dev libxt-dev libxext-dev libxml2-dev libfreetype6-dev liblcms1-dev libexif-dev perl libjasper-dev libltdl3-dev graphviz gs-gpl pkg-config -y"
    run "cd /tmp; wget ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-6.4.9-2.tar.gz"
    run "cd /tmp; tar -zxvf /tmp/ImageMagick-6.4.9-2.tar.gz"
    run "cd /tmp/ImageMagick-6.4.9-2; ./configure"
    run "cd /tmp/ImageMagick-6.4.9-2; make"
    run "cd /tmp/ImageMagick-6.4.9-2; make install"
    run "gem install rmagick"
  end
    
  task :ssl do
    run "a2enmod ssl"
    run "a2enmod headers"
    
    # Transfer keys (via SFTP)
    put File.read("#{rails_root}/config/ssl/server.crt"), "/etc/apache2/server.crt"
    put File.read("#{rails_root}/config/ssl/server.key"), "/etc/apache2/server.key"    
    
    # Restart Apache
    run "/etc/init.d/apache2 restart"
  end
    
end

namespace :webapp do

  desc "Configures Apache and Passenger for a new web app"
  task :init do
    template = ERB.new File.read("#{prefix}/lib/deploy/templates/apache-config.erb")
    prepared = template.result(binding)
    put prepared, "/etc/apache2/sites-available/#{application}"
    run "ln -s /etc/apache2/sites-available/#{application} /etc/apache2/sites-enabled/000-#{application}"
    symlink
    remove_default
  end
  
  task :gems do
    run "export LD_LIBRARY_PATH=/usr/local/lib; cd #{deploy_to}/current; /usr/bin/rake gems:install"
  end
  
  task :symlink do
    run "ln -s /var/rails/#{application}/current/public /var/www/#{application}"
  end
  
  desc "Correctly sets ownership of environment.rb for Passenger"  
  task :set_ownership do
    run "chown www-data:www-data #{current_path}/config/environment.rb"    
  end
      
  task :remove_default do
    run "rm /etc/apache2/sites-enabled/000-default"
  end
  
end

namespace :deploy do
  
  desc "Restart Apache"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "/etc/init.d/apache2 restart"
  end  
 
  [:start, :stop].each do |t|
    desc "#{t} task is unnecessary with Passenger"
    task t, :roles => :app do ; end
  end
  
end
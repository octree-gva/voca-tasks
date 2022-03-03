
FROM git.octree.ch:4567/decidim/vocacity/docker/dev-0.24:latest
ENV DECIDIM_PROCESS="sidekiq"

# Set work directory
WORKDIR /home/decidim/app

# set environment variables
ENV RAILS_ROOT "/home/decidim/app"
ENV DATABASE_HOST=localhost
ENV DATABASE_USERNAME=decidim_app
ENV DATABASE_PASSWORD=thepassword
ENV DATABASE_URL="postgres://decidim_app:thepassword@localhost:5432/decidim_application_development"

# create $RAILS_ROOT/public/uploads
RUN mkdir $RAILS_ROOT/public/uploads

# Copy gem content in a local directory
COPY . $RAILS_ROOT/decidim-module-vocacity_gem_tasks

# Add this directory as gem's path to the gemfile
RUN echo " " >> Gemfile
RUN echo "  gem \"decidim-vocacity_gem_tasks\", path: \"./decidim-module-vocacity_gem_tasks\"" >> Gemfile

# Install dependancies
RUN bundle install --quiet

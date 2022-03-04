
FROM git.octree.ch:4567/decidim/vocacity/docker/dev-0.24:latest
ENV DECIDIM_PROCESS="sidekiq"

# Set work directory
WORKDIR /home/decidim/app

# set environment variables
ENV RAILS_ROOT "/home/decidim/app"

# create $RAILS_ROOT/public/uploads
RUN mkdir $RAILS_ROOT/public/uploads

# Copy gem content in a local directory
COPY . $RAILS_ROOT/decidim-module-vocacity_gem_tasks

# Add this directory as gem's path to the gemfile
RUN echo " " >> Gemfile && echo "  gem \"decidim-vocacity_gem_tasks\", path: \"./decidim-module-vocacity_gem_tasks\"" >> Gemfile

# Install dependancies
RUN bundle config set with 'development' && bundle install

CMD ["bundle", "exec", "sidekiq"]

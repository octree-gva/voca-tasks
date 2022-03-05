
FROM git.octree.ch:4567/decidim/vocacity/docker/dev-0.24:latest
LABEL version="0.24"
LABEL description="Ruby alpine image with a decidim. \
Ready for building assets, and running decidim tasks."
LABEL license="AGPL-3.0"

ENV DECIDIM_PROCESS="sidekiq" \
    RAILS_JOB_MODE="sidekiq"\
    JOB_REDIS_URL="redis://redis:6379/1"

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

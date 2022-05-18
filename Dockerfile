
FROM git.octree.ch:4567/decidim/vocacity/docker/dev-0.24:latest
LABEL version="0.24"
LABEL description="Ruby alpine image with a decidim. \
Ready for building assets, and running decidim tasks."
LABEL license="AGPL-3.0"

ENV DECIDIM_PROCESS="sidekiq" \
    RAILS_JOB_MODE="sidekiq"\
    JOB_REDIS_URL="redis://redis:6379/1"\
    WEBHOOK_URL=""\
    WEBHOOK_HMAC=""\
    INSTANCE_UUID=""

# Set work directory
WORKDIR /home/decidim/app

# set environment variables
ENV RAILS_ROOT "/home/decidim/app"

# create $RAILS_ROOT/public/uploads
RUN mkdir -p $RAILS_ROOT/public/uploads && echo "DECIDIM_VERSION=$DECIDIM_VERSION"
# Copy gem content in a local directory
COPY . $RAILS_ROOT/decidim-module-vocacity_gem_tasks
# Copy necessary dependancies for sidekiq images.
COPY .docker/Gemfile-$DECIDIM_VERSION $RAILS_ROOT/tmp/Gemfile

# Add dependancies for gemfile and install
RUN cat $RAILS_ROOT/tmp/Gemfile >> Gemfile && \
    bundle config set without '' && \
    cat Gemfile && \
    bundle update
    

CMD ["bundle", "exec", "sidekiq"]


FROM git.octree.ch:4567/decidim/vocacity/docker/dev-0.24:latest
ENV DECIDIM_PROCESS="sidekiq"
# Copy gem content in a local directory
COPY . $RAILS_ROOT/vocacity-gem-tasks/

# Add this directory as gem's path to the gemfile
RUN echo "gem \"vocacity-tasks\", path: \"./vocacity-gem-tasks\"" >> Gemfile && \
    # Install dependancies
    bundle install --quiet

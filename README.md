### How did I do this?

* Get a basic cloudstack dev environment working. Follow instructions found
  [here](https://cwiki.apache.org/confluence/display/CLOUDSTACK/How+to+build+CloudStack).

    Using the information on
    [this](https://cwiki.apache.org/confluence/display/CLOUDSTACK/How+To+Generate+CloudStack+API+Documentation)
    page, and a lot of experimentation, I was able to find something that
    worked well enough.

* Make sure your paths match the following structure.

        $HOME
          projects
              cloudstack
                  cloudstack.orig (original cloudstack git clone)
              net-cloudstack-api

    and that net-cloudstack-api is in the parse_cloudstack_source branch.

### More details ...

I used a vmware instance, with my [Barebones CentOS
7 iso](https://github.com/harleypig/barebones-centos-7-iso) as the installed system.

### Contribute?

Please keep in mind, this was a hurry up. I didn't take the time to make
things neat and pretty.

If you want to make changes and a pull request, that would be great. All I ask
is that you keep the idea of "fixing the code" separate from "improving the
extracted data."

In other words, if there is a bug, or you have a better way to do something,
make that change but make sure the generated data is not any different.

Conversely, if you figure out how to find and add types to the generated data
(which would be awesome!) go ahead and add that code, but don't change any
thing else.

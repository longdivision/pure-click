# Pure Click

Scheduled runner for booking gym classes at [Pure Gym](http://www.puregym.com/).

## About

Uses [Capybara](https://github.com/jnicklas/capybara) with
[PhantomJS](http://phantomjs.org/) to make bookings,
[clockwork](https://github.com/tomykaira/clockwork) for scheduling.

Will work out of the box on Heroku's free tier.

## Usage

Depends on the following of environmental values:

* `PURE_URL`: The URL for the gym's website.
* `PURE_EMAIL`: The login email used for the gym's website.
* `PURE_PIN`: The login PIN you use for the gym's website.
* `PURE_SCHEDULE`: A serialized JSON schedule for the classes you want to book,
  demonstrated below. Can be serialised/unserialized using a tool like
  [Unserialize.md](http://www.unserialize.me/).

## Example Schedule JSON

The schedule JSON uses days of the week as root-level keys, 24hr class times as
second-level keys, and class names as second-level values, e.g.

```
{
  "Monday": {
    "18:10": "Class A Name",
    "19:00": "Class B Name"
  },
  "Wednesday": {
    "18:05": "Class A Name"
  },
  "Sunday": {
    "09:05": "Class C Name"
  }
}
```

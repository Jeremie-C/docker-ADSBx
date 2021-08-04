# docker-ADSBx

![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/jeremiec82/adsbx?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/jeremiec82/adsbx?style=plastic)
[![Deploy to Docker Hub](https://github.com/Jeremie-C/docker-ADSBx/actions/workflows/deploy.yml/badge.svg)](https://github.com/Jeremie-C/docker-ADSBx/actions/workflows/deploy.yml)
[![Check Code](https://github.com/Jeremie-C/docker-ADSBx/actions/workflows/check_code.yml/badge.svg)](https://github.com/Jeremie-C/docker-ADSBx/actions/workflows/check_code.yml)
[![Docker Build](https://github.com/Jeremie-C/docker-ADSBx/actions/workflows/test_build.yml/badge.svg)](https://github.com/Jeremie-C/docker-ADSBx/actions/workflows/test_build.yml)

Docker container to feed ADS-B data into [adsbexchange](https://www.adsbexchange.com).

## Environment Variables

| Environment Variable | Purpose | Default |
| -------------------- | ------- | ------- |
| `BEAST_HOST` | Required. IP/Hostname of a Mode-S/BEAST provider (readsb) |         |
| `BEAST_PORT` | Optional. TCP port number of Mode-S/BEAST provider (readsb) | `30005`   |
| `ADSBX_UUID` | Required. Your static UUID |  |
| `LATITUDE`   | Required. The latitude of the antenna |  |
| `LONGITUDE`  | Required. The longitude of the antenna |  |
| `ALTITUDE`   | Required. The altitude of the antenna above sea level. If positive (above sea level), must include either 'm' or 'ft' suffix to indicate |  |
| `SITENAME`   | Required. The name of your site (A-Z, a-z, `-`, `_`) | |
| `REDUCE_INTERVAL` | Optional. How often beastreduce data is transmitted to ADSBExchange. For low bandwidth feeds, this can be increased to `5` or even `10` | `0.5` |
| `PRIVACY`    | Optional. Setting this to yes will prevent feeder being shown on the [ADS-B Exchange Feeder Map](https://map.adsbexchange.com/mlat-map/)| `no` |
| `TZ`         | Optional. Your local timezone | `GMT` |
| `MLAT_RESULT2` | Optional. See "`MLAT_RESULT` syntax" below. |  |
| `MLAT_RESULT3` | Optional. See "`MLAT_RESULT` syntax" below. |  |
| `MLAT_RESULT4` | Optional. See "`MLAT_RESULT` syntax" below. |  |

#### `MLAT_RESULT` syntax

This variable allows you to configure incoming or outgoing connections.  
For outgoing connections : `protocol,connect,ip:port`  
For incomming connections : `protocol,listen,port`

* `protocol` can be one of the following:
  * `beast`: Beast-format output
  * `basestation`: Basestation-format output
  * `ext_basestation`: ext_Basestation-format output
* `ip` is an IP address. Specify an IP/hostname/containername for outgoing connections.
* `port` is a TCP port number

## Ports

| Port | Detail |
| ---- | ------ |
| 30105/tcp | MLAT Results Beast protocol output. Optional. Allow other applications outside docker host to receive MLAT results |

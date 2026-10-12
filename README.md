# tactix 7 Pro Minimal Watch Face

A dark Connect IQ watch face for the Garmin tactix 7 Pro (280x280 MIP, Connect IQ device id `fenix7x`):

- owner name and date `mm/dd/yyyy` at the top
- large 24-hour time in the middle
- step icon + today's steps, battery icon (filled to charge level) + estimated days left at the bottom
- optional US flag background during the first minute of each hour

Written in Monkey C.

## Customize (on the watch)

Hold UP > Watch Face > Tactix7 Minimal > Customize:

- Hours color, Colon color, Minutes color
- Show colon (on/off)
- Hourly US flag (on/off)

To change the name shown at the top, edit `OWNER_NAME` in `source/Tactix7FaceView.mc`.

## Prerequisites

- Java 17: `brew install openjdk@17`
- Connect IQ SDK (installed under `~/Library/Application Support/Garmin/ConnectIQ/Sdks`)
- **Device definition:** open `/Applications/SdkManager.app`, sign in with a Garmin account, go to **Devices**, and download **fēnix 7X / tactix 7 / quatix 7X Solar / Enduro 2**.
- Developer key at `~/.garmin/developer_key.der`. To generate one:

  ```bash
  openssl genrsa -out developer_key.pem 4096
  openssl pkcs8 -topk8 -inform PEM -outform DER -in developer_key.pem -out developer_key.der -nocrypt
  ```

## Build and run

```bash
./build.sh        # builds bin/Tactix7Face.prg
./build.sh run    # builds, starts the simulator, loads the face
```

To fine-tune layout spacing, change `ROW_OFFSET` / `OWNER_NAME_OFFSET` in `source/Tactix7FaceView.mc`.

## Install on the watch (sideload)

1. Connect the watch over USB. macOS needs an MTP client, e.g. [OpenMTP](https://openmtp.ganeshrvel.com/).
2. Copy `bin/Tactix7Face.prg` into `GARMIN/APPS/` on the watch.
3. Disconnect, then on the watch go to **Watch Face** and select **Tactix7 Minimal**.

To remove it, delete the `.prg` from `GARMIN/APPS/`.

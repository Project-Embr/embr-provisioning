source "arm" "alpine" {
  file_checksum_type    = "sha256"
  file_checksum_url     = "http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/aarch64/alpine-minirootfs-3.12.0-aarch64.tar.gz.sha256"
  file_target_extension = "tar.gz"
  file_unarchive_cmd    = ["bsdtar", "-xpf", "$ARCHIVE_PATH", "-C", "$MOUNTPOINT"]
  file_urls             = ["http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/aarch64/alpine-minirootfs-3.12.0-aarch64.tar.gz"]
  image_build_method    = "new"
  image_chroot_env      = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/sbin:/usr/sbin"]
  image_partitions {
    filesystem   = "ext4"
    mountpoint   = "/"
    name         = "root"
    size         = "0"
    start_sector = "4096"
    type         = "83"
  }
  image_path                   = "alpine.img"
  image_size                   = "4G"
  image_type                   = "dos"
  qemu_binary_destination_path = "/usr/bin/qemu-arm-static"
  qemu_binary_source_path      = "/usr/bin/qemu-arm-static"
}

build {
  sources = ["source.arm.alpine"]

  provisioner "shell" {
    inline = [
      "touch /root/test",
      "echo 'nameserver 8.8.8.8' > /etc/resolv.conf",
      "apk update",
      "apk add wireless-tools wpa_supplicant alpine-conf"
    ]
  }

  provisioner "file" {
    source = "./systems/rpi4/interfaces"
    destination = "/tmp/interfaces"
  }

  provisioner "shell" {
    inline = [
      "setup-hostname -n embr",
      "setup-interfaces -i < /tmp/interfaces"
    ]
  }

}

#!/usr/bin/env bash

bundler() {
    state=()
    local indexsh=$1
    local outPath=$2
    copyToFile "$indexsh" "$outPath"
}

'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "64dc9f967b756d60f0ab94e1c0f09c04",
"version.json": "72f34a2d5755f1073f9f0bcf92749a00",
"index.html": "f53aaa073f5330947f0004ab161468ba",
"/": "f53aaa073f5330947f0004ab161468ba",
"vercel.json": "da8484efebd780414370117c48fcb6e4",
"main.dart.js": "744a58330d63a5fa54ee0b411309c657",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"_redirects": "6a02faf7ea2a9584134ffe15779a0e44",
"favicon.png": "7c26bd34cd01e7562d5b2553452ea57e",
"icons/Icon-192.png": "ff6e56e06e166ff0700a4b5c5909996f",
"icons/Icon-maskable-192.png": "ff6e56e06e166ff0700a4b5c5909996f",
"icons/Icon-maskable-512.png": "fd9dab010e4b962e6d3d383d37bfab55",
"icons/Icon-512.png": "fd9dab010e4b962e6d3d383d37bfab55",
"manifest.json": "7c7e26d2b123e260f4c80fd34d6f9499",
"assets/AssetManifest.json": "f260168e4e0d882bc2993d9e3a617b8e",
"assets/NOTICES": "88d7f53b590f1a29fcd041ea2efa4b8f",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "d2bec3096e95d8a3da4c834f352e1545",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "81a699477ac430ffba7f2370e66a2ce1",
"assets/fonts/MaterialIcons-Regular.otf": "73b88783538f6b34c431c7876c07419f",
"assets/assets/images/Cold%2520Coffee.png": "0c9b64b87ae6e29d908d88d8c42cc07a",
"assets/assets/images/tools/link.png": "4c187bb5cfafe26bd7afb01143e038e7",
"assets/assets/images/tools/FruteriaLaUnica_bg.jpg": "6c06b0bb1bad09041e47b3fc3316c3a4",
"assets/assets/images/tools/fb.png": "1078eb7dd1b25ee4af15030d0aac042c",
"assets/assets/images/tools/cooking.png": "b558d3acaca9f85d2bf2327953a55b4b",
"assets/assets/images/tools/4uRestFont-white.png": "0ec17f6c29969e366c8e7a9d24eb1fed",
"assets/assets/images/tools/4uRest-DM-3.png": "d3f940bd85d48aeee63fc2988cd9d139",
"assets/assets/images/tools/4uRestIcon-black.png": "c62ea597bf154430273166dd11573a31",
"assets/assets/images/tools/4uRest-DM-3.jpg": "b72901c3fc1f45f1d83a6fe7c2484333",
"assets/assets/images/tools/whatsapp1.png": "8b7710cc4e27d38b94b4448f96b645e1",
"assets/assets/images/tools/insta.png": "6e13497c04c2074529991f8671546349",
"assets/assets/images/tools/whatsapp.png": "b842f0a66518b5f988bdf53a8f89bcc2",
"assets/assets/images/Black%2520Coffee.png": "6f7b9b48b0c77403457f62850462e696",
"assets/assets/images/Espresso.png": "5316d1868b5cf052baf0519214d10b75",
"assets/assets/images/Latte.png": "b0c92405a9e04a46bc1d294e8927e7f1",
"assets/assets/images/bg.png": "75e90a8c5ad505fb37a58a75e2351b3e",
"assets/assets/feedback/triste.png": "fad0d21863486e9fef44e02f642d2954",
"assets/assets/feedback/feliz.png": "02543668b6881fcae92fd9cbc78f70de",
"assets/assets/feedback/confuso.png": "7aaa9691248486682948d20575f3778b",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

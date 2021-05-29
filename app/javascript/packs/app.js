import * as GLTFLoader from "../lib/js/m/GLTFLoader.js";
import * as LineMaterial from "../lib/js/lines/LineMaterial.js";
import * as Wireframe from "../lib/js/lines/Wireframe.js";
import * as WireframeGeometry2 from "../lib/js/lines/WireframeGeometry2.js";
import * as THREE from "../build/three.module.js";

const LineMat = LineMaterial.LineMaterial;
const Wire = Wireframe.Wireframe;
const WireGeo = WireframeGeometry2.WireframeGeometry2;
const sin = Math.sin;
const cos = Math.cos;
const PI = Math.PI;
const round = Math.round;
const rand = THREE.MathUtils.randFloatSpread;
const now = Date.now;
const scene = new THREE.Scene();
scene.background = new THREE.Color(0x0D1918);
scene.fog = new THREE.FogExp2( 0x001110, 0.0011 );

const camera = new THREE.PerspectiveCamera(80, window.innerWidth / window.innerHeight, 0.1, 1000 );

const listener = new THREE.AudioListener();
const ac = listener.context;
camera.add(listener);

const gain = listener.getInput();
const oscs = [];
var starts = 0;
const startAudio = function(e) {
  if (starts>2) return;
  for (var i=0;i<3;i++) {
    const o = ac.createOscillator();
    o.type='triangle';
    o.frequency.setValueAtTime((5*6^i)+cos(now()^-i), ac.currentTime);

    const sound = new THREE.Audio(listener);
    sound.setNodeSource(o);
    o.start(0);
    oscs.push(o);
    sound.gain.gain.setValueAtTime(0,ac.currentTime);
    sound.gain.gain.linearRampToValueAtTime(0.1,ac.currentTime+3);
  }

  starts+=1;
}
startAudio();
window.addEventListener('touchstart', startAudio);
document.addEventListener('click', startAudio);

var last = 0;
window.clicky = function() {
  if (last+300>=now()) return;
  last=now();
  for (var i=0;i<3;i++) {
    const o = ac.createOscillator();
    o.type='triangle';
    o.frequency.setValueAtTime(60.01*(4+i), ac.currentTime);
    const sound = new THREE.Audio(listener);
    sound.gain.gain.setValueCurveAtTime([0,0.06,0],ac.currentTime,0.2);
    sound.setNodeSource(o);
    o.start(0);
  }
}
window.beepy = function() {
  window.clicky();
  for (var i=0;i<3;i++) {
    const o = ac.createOscillator();
    o.type='sine';
    o.frequency.setValueAtTime(120.01*(4+i), ac.currentTime);
    const sound = new THREE.Audio(listener);
    sound.gain.gain.setValueCurveAtTime([0,0.02,0],ac.currentTime,0.65);
    sound.setNodeSource(o);
    o.start(0);
  }
};
window.wompy = function() {
  window.clicky();
  for (var i=0;i<3;i++) {
    const o = ac.createOscillator();
    o.type='square';
    o.frequency.setValueCurveAtTime([120+i*66,20],ac.currentTime+0.1,0.9);
    const sound = new THREE.Audio(listener);
    sound.gain.gain.setValueCurveAtTime([0.01,0.03,0.01,0],ac.currentTime,0.9);
    o.start(0);
    sound.setNodeSource(o);
  }
};
document.addEventListener("turbolinks:load", () => {
  var a = document.getElementsByTagName("a");
  for (var i=0;i<a.length;i++) {
    a[i].addEventListener('click',window.clicky);
  }
  a = document.getElementById("notice");
  if (a) {
    window.beepy();
  }

});

const renderer = new THREE.WebGLRenderer({antialias: true});
renderer.setClearColor( 0x000000, 0.0 );

const sphereGeometry = new THREE.SphereGeometry(3,9,8);
const sphereWire = new WireGeo(sphereGeometry);
const lineMat = new LineMat( { color: 0x33F8ED,
  linewidth: 0.0014, opacity: 0.6, transparent: true  } );

const planet = new Wire( sphereWire, lineMat );
scene.add( planet );

const moons = [];
for ( let i = 0; i < 12; i ++ ) {
  const moonGeoS = new THREE.SphereGeometry(3+rand(4),
  4+round(rand(5)),
  4+round(rand(5)));
  const moonGeo = new WireGeo(moonGeoS);
  const moon = new Wire( moonGeo, lineMat );
  moons.push(moon);
  scene.add( moon );
}

const phong = new THREE.MeshPhongMaterial( {
  color: 0x73F8ED,
  shininess: 100,
  emissive: 0x001515
} );

const stars = [];
for ( let i = 0; i < 20000; i ++ ) {
  const x = rand( 2000 )^2;
  const y = rand( 2000 )^2;
  const z = rand( 2000 )^2;
  stars.push( x, y, z );
}
const geometry = new THREE.BufferGeometry();
geometry.setAttribute( 'position', new THREE.Float32BufferAttribute( stars, 3 ) );
const material = new THREE.PointsMaterial( { color: 0x73F8ED } );
const starsMesh = new THREE.Points( geometry, material );
scene.add( starsMesh );

const light = new THREE.PointLight( 0xccffff, 0.8, );
light.position.set(-222,777,333);
scene.add( light );
const mlight = new THREE.DirectionalLight( 0xff325D, .5 );
mlight.position.set(222,-999,-222);
mlight.target = planet;
scene.add(mlight);

const loader = new GLTFLoader.GLTFLoader();
loader.load(window.GLTF_URL, function ( gltf ) {
  let catgeo = gltf.scene.children[0].geometry;
  let coingeo = gltf.scene.children[1].geometry;
  let handgeo = gltf.scene.children[2].geometry;
  let egggeo = gltf.scene.children[3].geometry;
  let satgeo = gltf.scene.children[4].geometry;
  let heartgeo = gltf.scene.children[5].geometry;
  let dogegeo = gltf.scene.children[6].geometry;
  let tabgeo = gltf.scene.children[7].geometry;

  const catWire = new WireGeo(tabgeo);
  const catLine = new LineMat( { color: 0x003939,
    linewidth: 0.002, opacity: 0.6, transparent: true  } );
  const catcat = new Wire(catWire, catLine);
  let catmesh = new THREE.Mesh( tabgeo,  new THREE.MeshPhongMaterial( {
    color: 0x559999,
    shininess: 0
  } ) );
  catmesh.scale.setScalar(.997);
  catcat.add(catmesh);
  catcat.visible=false;
  const cat = new THREE.Group();
  cat.add(catcat);
  const catP = new THREE.Group();
  catP.add(cat)
  scene.add(catP);

  const doge = new Wire( new WireGeo(dogegeo),
    new LineMat( { color: 0xf8c24D,
    linewidth: 0.0014, opacity: 0.6, transparent: true  } ) );
  let dogemesh = new THREE.Mesh( dogegeo, new THREE.MeshPhongMaterial( {
    color: 0xf8a22D,
    shininess: 100,
    emissive: 0x101005
  } ) );
  dogemesh.scale.setScalar(.998);
  doge.add(dogemesh);
  doge.visible=false;
  cat.add(doge);

  const tabWire = new WireGeo(catgeo);
  const tab = new Wire( tabWire, lineMat  );
  let tabmesh = new THREE.Mesh( catgeo, phong );
  tabmesh.scale.setScalar(.998);
  tab.add(tabmesh);
  cat.add(tab);

  const coin = new Wire(new WireGeo(coingeo), lineMat);
  let coinmesh = new THREE.Mesh( coingeo, phong );
  coinmesh.scale.y=.95;
  coin.add(coinmesh);
  scene.add(coin);

  const hand = new Wire(new WireGeo(handgeo), lineMat);
  let handmesh = new THREE.Mesh( handgeo, phong );
  handmesh.scale.setScalar(.99);
  hand.add(handmesh);
  hand.scale.setScalar(.7);
  cat.add(hand);

  const egg = new Wire(new WireGeo(egggeo), lineMat);
  let eggmesh = new THREE.Mesh( egggeo, phong );
  eggmesh.scale.y=.98;
  eggmesh.scale.z=.98;
  egg.add(eggmesh);
  scene.add(egg);

  const sat = new Wire(new WireGeo(satgeo), lineMat);
  let satmesh = new THREE.Mesh( satgeo, phong );
  satmesh.scale.setScalar(.998);
  sat.add(satmesh);
  scene.add(sat);
  sat.rotation.set(rand(PI),rand(PI),rand(PI));

  const heart = new Wire(new WireGeo(heartgeo),  new LineMat( { color: 0xf8429D,
    linewidth: 0.0015, opacity: 0.6, transparent: true  }) );
  let heartmesh = new THREE.Mesh( heartgeo, new THREE.MeshPhongMaterial( {
    color: 0xf8429D,
    shininess: 100,
    emissive: 0x100005
  } ) );
  heartmesh.scale.setScalar(.998);
  heart.add(heartmesh);
  cat.add(heart);
  heart.scale.setScalar(0.6);
  heart.position.z=0.4;
  heart.rotation.y=0.25;
  renderer.phenoMap = [
    // gender
    [],
    // size
    [()=>{cat.scale.setScalar(.6);cat.scale.x=.44;catP.position.y+=-.24},
      ()=>{cat.scale.setScalar(.8)},
      ()=>{cat.scale.setScalar(.8);cat.scale.x=1.5;},
      ()=>{cat.scale.setScalar(.15);catP.position.y+=-1},
      ()=>{cat.scale.x=.7+sin(now()/9e2)/4;cat.scale.y=.6-cos(now()/2e3)/4},
      ()=>{cat.scale.x=2.5;cat.scale.y=.8;catP.position.y+=.08}],
    // breed
    [()=>{doge.visible=false;catcat.visible=true;tab.visible=false},
      ()=>{catcat.visible=false;doge.visible=false;tab.visible=true},
      ()=>{catcat.visible=false;doge.visible=true;tab.visible=false}],
    // eyes
    []
  ];
  const updateModels = function(){
    requestAnimationFrame(updateModels);
    coin.rotation.z += 0.01;
    egg.position.y=999;
    sat.position.x=-45;
    catP.position.setY(4.15);
    catP.scale.setScalar(1.1);
    catP.rotation.set(0,0,0);
    cat.position.setY(0);
    if(renderer.flyTo=="coin") {
      camera.position.copy(
        planet.position.clone().setX(coin.position.x+10)
        .sub(camera.position).divideScalar(4));
      camera.lookAt(coin.position);
      catP.position.setY(999);
    }
    if (renderer.flyTo=="cat" || renderer.flyTo=="hand") {
      catP.scale.setScalar(.7);
      catP.position.y=1;

      coin.rotation.z=0;
      coin.rotation.x=PI;

      camera.position.copy(
        catP.position.clone().setZ(catP.position.z+12)
        .setY(catP.position.y+6)
        .setX(catP.position.x+3)
        .sub(camera.position).divideScalar(4));
      camera.lookAt(catP.position.clone().setX(catP.position.x-1.2));
    } else if (renderer.flyTo=="stray") {
      catP.position.y+=(42-catP.position.y)/4.0;
      catP.rotation.set(sin(now()/3e4)*2,
        cos(now()/1e4)*2,
        sin(now()/2e4)*2);

      camera.position.copy(
        catP.position.clone().setX(catP.position.x+4)
        .setY(catP.position.y-1.4));
      camera.lookAt(catP.position.clone().setZ(catP.position.z+.8));
    } else if (renderer.flyTo=="egg") {
      egg.position.y=0.59;
      cat.position.y=99;
      coin.rotation.z=0;
      coin.rotation.x=PI

      camera.position.copy(
        egg.position.clone().setZ(egg.position.z-12)
        .setY(egg.position.y+3)
        .sub(camera.position).divideScalar(4));
      camera.lookAt(egg.position);
    } else {

      coin.rotation.x+=(-PI/2-coin.rotation.x)/4.0;
    }
    if (renderer.flyTo=="moon") {
      camera.position.copy(
        sat.position.clone().setX(sat.position.x-120)
        .sub(camera.position).divideScalar(2));

      camera.lookAt(sat.position);
    }
    if (renderer.flyTo=="hand") {
    hand.rotation.set(-1.15,1.1,1);
    hand.position.set(0.6+cos(now()/5e2)/6,
      0.45+cos(now()/5e2)/8,
      0.6+sin(now()/5e2)/2);
      heart.position.y=(6+2*(cos(now()/2e2)/20)-heart.position.y)/2.0;
    } else {
      hand.position.y+=(999-hand.position.y)/4.0;
      heart.position.y=(-999-heart.position.y)/2.0;
    }

    if (renderer.pheno) {
      for (var p = 0; p<renderer.pheno.length; p++) {
        if (renderer.phenoMap && renderer.phenoMap[p] && renderer.phenoMap[p].length > renderer.pheno[p]) {
          renderer.phenoMap[p][renderer.pheno[p]]();
        }
      }
    }
  };updateModels();

});

const animate = function () {
  requestAnimationFrame( animate );
  moons.forEach((moon,i) => {
    const r = moon.geometry.id/4;
    moon.position.z = sin(r*now()/4e5)*2*(r*10);
    moon.position.x = cos(r*now()/5e5)*3*(r*10);
  });

  scene.rotation.x = +cos(now()/3e4)/20;
  scene.rotation.y = +sin(now()/2e4)/10;
  //scene.rotation.z = +cos(now()/3e4)/10;

  if(renderer.flyTo=="origin") {
    const p = planet.position.clone().setY(planet.position.y+2).setX(planet.position.x-4);
    camera.position.copy(
      p.clone().setZ(planet.position.z+28)
      .setX(planet.position.x+13)
      .setY(planet.position.y+20)
      .sub(camera.position).divideScalar(4));
    camera.lookAt(p);
  }
  renderer.render( scene, camera );
};

scene.rotation.y = -rand();
animate();

window.renderer = renderer;

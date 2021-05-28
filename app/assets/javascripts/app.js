THREE = window.THREE;
const GLTFLoader = THREE.GLTFLoader;

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
    o.frequency.setValueAtTime((5*6^i)+Math.cos(Date.now()^-i), ac.currentTime);

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
  if (last+300>=Date.now()) return;
  last=Date.now();
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

const boxGeometry = new THREE.SphereGeometry(3,9,8);
const boxMaterial = new THREE.MeshBasicMaterial( { color: 0x73F8ED,
  wireframe: true, opacity: 0.8, transparent: true  } );

const phong = new THREE.MeshPhongMaterial( {
  color: 0x73F8ED,
  shininess: 100,
  emissive: 0x001515
} );

const rand = THREE.MathUtils.randFloatSpread;
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
const moons = [];
for ( let i = 0; i < 12; i ++ ) {
  const moonGeo = new THREE.SphereGeometry(3+rand(4),
  4+Math.round(rand(5)),
  4+Math.round(rand(5)));
  const moon = new THREE.Mesh( moonGeo, boxMaterial );
  moons.push(moon);
  scene.add( moon );
}

const planet = new THREE.Mesh( boxGeometry, boxMaterial );
scene.add( planet );

const light = new THREE.PointLight( 0xccffff, 0.8, );
light.position.set(-222,777,333);
scene.add( light );
const mlight = new THREE.DirectionalLight( 0xff224D, 0.6 );
mlight.position.set(222,-999,-222);
mlight.target = planet;
scene.add(mlight);

const loader = new GLTFLoader();
loader.load(window.GLTF_URL, function ( gltf ) {

  let catgeo = gltf.scene.children[0].geometry;
  const cat = new THREE.Mesh(catgeo, boxMaterial);
  let catmesh = new THREE.Mesh( catgeo, phong );
  catmesh.scale.setScalar(.998);
  cat.add(catmesh);
  scene.add(cat);

  let coingeo = gltf.scene.children[1].geometry;
  const coin = new THREE.Mesh(coingeo, boxMaterial);
  let coinmesh = new THREE.Mesh( coingeo, phong );
  coinmesh.scale.y=.95;
  coin.add(coinmesh);
  scene.add(coin);

  let handgeo = gltf.scene.children[2].geometry;
  const hand = new THREE.Mesh(handgeo, boxMaterial);
  let handmesh = new THREE.Mesh( handgeo, phong );
  handmesh.scale.setScalar(.99);
  hand.add(handmesh);
  scene.add(hand);
  hand.scale.setScalar(.4);

  let egggeo = gltf.scene.children[3].geometry;
  const egg = new THREE.Mesh(egggeo, boxMaterial);
  let eggmesh = new THREE.Mesh( egggeo, phong );
  eggmesh.scale.y=.98;
  eggmesh.scale.z=.98;
  egg.add(eggmesh);
  scene.add(egg);

  let satgeo = gltf.scene.children[4].geometry;
  const sat = new THREE.Mesh(satgeo, boxMaterial);
  let satmesh = new THREE.Mesh( satgeo, phong );
  satmesh.scale.setScalar(.998);
  sat.add(satmesh);
  scene.add(sat);
  sat.rotation.set(rand(Math.PI),rand(Math.PI),rand(Math.PI));

  let heartgeo = gltf.scene.children[5].geometry;
  const heart = new THREE.Mesh(heartgeo,  new THREE.MeshBasicMaterial( { color: 0xf8429D,
    wireframe: true, opacity: 0.8, transparent: true  }) );
  let heartmesh = new THREE.Mesh( heartgeo, new THREE.MeshPhongMaterial( {
    color: 0xf8429D,
    shininess: 100,
    emissive: 0x100005
  } ) );
  heartmesh.scale.setScalar(.998);
  heart.add(heartmesh);
  scene.add(heart);
  heart.scale.setScalar(0.3);
  heart.position.z=0.4;
  heart.rotation.y=0.25;

  const updateModels = function(){
    requestAnimationFrame(updateModels);
    coin.rotation.z += 0.01;
    egg.position.y=999;
    sat.position.x=-45;
    if(renderer.flyTo=="coin") {
      camera.position.copy(
        planet.position.clone().setX(coin.position.x+10)
        .sub(camera.position).divideScalar(4));
      camera.lookAt(coin.position);
    }
    if(renderer.flyTo=="cat" || renderer.flyTo=="hand") {
      cat.scale.copy(cat.scale.clone().addScalar(4).sub(cat.scale).divideScalar(7))
      cat.position.y+=(1.02-cat.position.y)/4.0;

      coin.rotation.z=0;
      coin.rotation.x=Math.PI

      camera.position.copy(
        cat.position.clone().setZ(cat.position.z+10)
        .setY(cat.position.y+6)
        .setX(cat.position.x+5)
        .sub(camera.position).divideScalar(4));
      camera.lookAt(cat.position.clone().setZ(cat.position.z+.7));
    } else if (renderer.flyTo=="stray") {
      cat.position.y+=(20-cat.position.y)/4.0;
      cat.rotation.set(Math.sin(Date.now()/3e4)*2,
        Math.cos(Date.now()/1e4)*2,
        Math.sin(Date.now()/2e4)*2);

      camera.position.copy(
        cat.position.clone().setX(cat.position.x+25)
        .setY(cat.position.y+30)
        .sub(camera.position).divideScalar(2));
      camera.lookAt(cat.position.clone().setY(cat.position.y-1));
    } else if (renderer.flyTo=="egg") {
      egg.position.y=0.59;
      cat.position.y=99;
      coin.rotation.z=0;
      coin.rotation.x=Math.PI

      camera.position.copy(
        egg.position.clone().setZ(egg.position.z-12)
        .setY(egg.position.y+3)
        .sub(camera.position).divideScalar(4));
      camera.lookAt(egg.position);
    } else {
      cat.position.y+=(4.25-cat.position.y)/3.0;
      cat.scale.copy(cat.scale.clone().addScalar(4).sub(cat.scale).divideScalar(4));
      cat.rotation.z=0;
      cat.rotation.x=0;
      coin.rotation.x+=(-Math.PI/2-coin.rotation.x)/4.0;
    }
    if (renderer.flyTo=="moon") {
      camera.position.copy(
        sat.position.clone().setX(sat.position.x-120)
        .sub(camera.position).divideScalar(2));

      camera.lookAt(sat.position);
    }
    if (renderer.flyTo=="hand") {
    hand.rotation.set(-1,1.1,1);
    hand.position.set(0.43+Math.cos(Date.now()/5e2)/6,
      1.35+Math.cos(Date.now()/5e2)/8,
      0.4+Math.sin(Date.now()/5e2)/2);
      heart.position.y=(6+2*(Math.cos(Date.now()/2e2)/20)-heart.position.y)/2.0;
    } else {
      hand.position.y+=(999-hand.position.y)/4.0;
      heart.position.y=(-999-heart.position.y)/2.0;
    }
  };updateModels();

});

const animate = function () {
  requestAnimationFrame( animate );
  moons.forEach((moon,i) => {
    const r = moon.geometry.parameters.radius+2;
    moon.position.z = Math.sin(r*Date.now()/4e5)*2*(r*10);
    moon.position.x = Math.cos(r*Date.now()/5e5)*3*(r*10);
  });

  scene.rotation.x = +Math.cos(Date.now()/3e4)/20;
  scene.rotation.y = +Math.sin(Date.now()/2e4)/10;
  //scene.rotation.z = +Math.cos(Date.now()/3e4)/10;

  if(renderer.flyTo=="origin") {
    const p = planet.position.clone().setY(planet.position.y+2).setX(planet.position.x-1);
    camera.position.copy(
      p.clone().setZ(planet.position.z+28)
      .setX(planet.position.x+20)
      .setY(planet.position.y+20)
      .sub(camera.position).divideScalar(4));
    camera.lookAt(p);
  }
  renderer.render( scene, camera );
};

scene.rotation.y = -Math.random();
animate();

window.renderer = renderer;

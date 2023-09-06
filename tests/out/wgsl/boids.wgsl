struct Particle {
    pos: vec2<f32>,
    vel: vec2<f32>,
}

struct SimParams {
    deltaT: f32,
    rule1Distance: f32,
    rule2Distance: f32,
    rule3Distance: f32,
    rule1Scale: f32,
    rule2Scale: f32,
    rule3Scale: f32,
}

struct Particles {
    particles: array<Particle>,
}

const NUM_PARTICLES: u32 = 1500u;

@group(0) @binding(0) 
var<uniform> params: SimParams;
@group(0) @binding(1) 
var<storage> particlesSrc: Particles;
@group(0) @binding(2) 
var<storage, read_write> particlesDst: Particles;

@compute @workgroup_size(64, 1, 1) 
fn main(@builtin(global_invocation_id) global_invocation_id: vec3<u32>) {
    var vPos: vec2<f32>;
    var vVel: vec2<f32>;
    var cMass: vec2<f32>;
    var cVel: vec2<f32>;
    var colVel: vec2<f32>;
    var cMassCount: i32;
    var cVelCount: i32;
    var pos: vec2<f32>;
    var vel: vec2<f32>;
    var i: u32;

    let index = global_invocation_id.x;
    if (index >= NUM_PARTICLES) {
        return;
    }
    let _e8 = particlesSrc.particles[index].pos;
    vPos = _e8;
    let _e14 = particlesSrc.particles[index].vel;
    vVel = _e14;
    cMass = vec2<f32>(0.0, 0.0);
    cVel = vec2<f32>(0.0, 0.0);
    colVel = vec2<f32>(0.0, 0.0);
    cMassCount = 0;
    cVelCount = 0;
    i = 0u;
    loop {
        let _e36 = i;
        if (_e36 >= NUM_PARTICLES) {
            break;
        }
        let _e39 = i;
        if (_e39 == index) {
            continue;
        }
        let _e43 = i;
        let _e46 = particlesSrc.particles[_e43].pos;
        pos = _e46;
        let _e49 = i;
        let _e52 = particlesSrc.particles[_e49].vel;
        vel = _e52;
        let _e53 = pos;
        let _e54 = vPos;
        let _e58 = params.rule1Distance;
        if (distance(_e53, _e54) < _e58) {
            let _e60 = cMass;
            let _e61 = pos;
            cMass = (_e60 + _e61);
            let _e63 = cMassCount;
            cMassCount = (_e63 + 1);
        }
        let _e66 = pos;
        let _e67 = vPos;
        let _e71 = params.rule2Distance;
        if (distance(_e66, _e67) < _e71) {
            let _e73 = colVel;
            let _e74 = pos;
            let _e75 = vPos;
            colVel = (_e73 - (_e74 - _e75));
        }
        let _e78 = pos;
        let _e79 = vPos;
        let _e83 = params.rule3Distance;
        if (distance(_e78, _e79) < _e83) {
            let _e85 = cVel;
            let _e86 = vel;
            cVel = (_e85 + _e86);
            let _e88 = cVelCount;
            cVelCount = (_e88 + 1);
        }
        continuing {
            let _e91 = i;
            i = (_e91 + 1u);
        }
    }
    let _e94 = cMassCount;
    if (_e94 > 0) {
        let _e97 = cMass;
        let _e98 = cMassCount;
        let _e101 = vPos;
        cMass = ((_e97 / f32(_e98)) - _e101);
    }
    let _e103 = cVelCount;
    if (_e103 > 0) {
        let _e106 = cVel;
        let _e107 = cVelCount;
        cVel = (_e106 / f32(_e107));
    }
    let _e110 = vVel;
    let _e111 = cMass;
    let _e114 = params.rule1Scale;
    let _e117 = colVel;
    let _e120 = params.rule2Scale;
    let _e123 = cVel;
    let _e126 = params.rule3Scale;
    vVel = (((_e110 + (_e111 * _e114)) + (_e117 * _e120)) + (_e123 * _e126));
    let _e129 = vVel;
    let _e131 = vVel;
    vVel = (normalize(_e129) * clamp(length(_e131), 0.0, 0.1));
    let _e137 = vPos;
    let _e138 = vVel;
    let _e141 = params.deltaT;
    vPos = (_e137 + (_e138 * _e141));
    let _e145 = vPos.x;
    if (_e145 < -1.0) {
        vPos.x = 1.0;
    }
    let _e151 = vPos.x;
    if (_e151 > 1.0) {
        vPos.x = -1.0;
    }
    let _e157 = vPos.y;
    if (_e157 < -1.0) {
        vPos.y = 1.0;
    }
    let _e163 = vPos.y;
    if (_e163 > 1.0) {
        vPos.y = -1.0;
    }
    let _e172 = vPos;
    particlesDst.particles[index].pos = _e172;
    let _e177 = vVel;
    particlesDst.particles[index].vel = _e177;
    return;
}

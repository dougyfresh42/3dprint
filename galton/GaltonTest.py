import sys, random
import pygame
from pygame.locals import *
import pymunk
import pymunk.pygame_util
import math

def add_ball(space, x, y, radius):
    """Add a ball to the given space at a random position"""
    mass = 1
    inertia = pymunk.moment_for_circle(mass, 0, radius, (0,0))
    body = pymunk.Body(mass, inertia)
    body.position = x, y
    shape = pymunk.Circle(body, radius, (0,0))
    space.add(body, shape)
    return shape

def add_balls(space, x_init, y_init, total_h, total_w, radius):
    x_start = x_init + 30
    y_start = y_init + total_h - 10
    x = x_start
    y = y_start
    for i in range(5):
      while x < x_init + total_w - 30:
        add_ball(space, x, y, radius)
        x = x + 2 * radius + 1
      y = y - 2 * radius - 1
      x = x_start

def add_outline(space, x_init, y_init, total_h, total_w):
    body = pymunk.Body(body_type = pymunk.Body.STATIC)
    body.position = (0, 0)
    l1 = pymunk.Segment(body, (x_init, y_init), (x_init + total_w, y_init), 5)
    l2 = pymunk.Segment(body, (x_init + total_w, y_init), (x_init + total_w, y_init + total_h), 5)
    l3 = pymunk.Segment(body, (x_init + total_w, y_init + total_h), (x_init, y_init + total_h), 5)
    l4 = pymunk.Segment(body, (x_init, y_init + total_h), (x_init, y_init), 5)
    space.add(l1, l2, l3, l4)

def add_ramps(space, x_init, y_init, total_h, total_w, funnel_angle, funnel_height, funnel_width):
    body = pymunk.Body(body_type = pymunk.Body.STATIC)
    body.position = (0, 0)

    xr1 = x_init + (total_w + funnel_width) / 2
    xl1 = x_init + (total_w - funnel_width) / 2
    yr1 = y_init + total_h - (total_h * funnel_height / 100)
    yl1 = yr1

    xr2 = x_init + total_w
    xl2 = x_init
    yr2 = yr1 + (xr2 - xr1)*math.tan(funnel_angle * math.pi / 180)
    yl2 = yr2

    l1 = pymunk.Segment(body, (xr1,yr1), (xr2,yr2), 1)
    l2 = pymunk.Segment(body, (xl1,yl1), (xl2,yl2), 1)

    space.add(l1, l2)
    return l1, l2

def add_pins(space, x_init, y_init, total_h, total_w, funnel_height, separation_distance, pin_total, pin_diam, pin_horz, pin_vert):
    #row 1
    startpinx = x_init + total_w / 2
    startpiny = y_init + total_h - (total_h * funnel_height / 100) - (total_h * separation_distance / 100) - pin_diam / 2

    centercenterx = pin_horz + pin_diam
    fitnumpins = (total_w//2) // centercenterx

    piny = startpiny
    pinx = startpinx - fitnumpins * centercenterx
    indent = True
    while (startpiny - piny) < (total_h * pin_total / 100):
      while pinx < total_w + x_init:
        body = pymunk.Body(body_type = pymunk.Body.STATIC)
        body.position = pinx, piny
        shape = pymunk.Circle(body, pin_diam/2, (0,0))
        space.add(shape)
        pinx = pinx + centercenterx
      piny = piny - pin_vert - pin_diam
      if indent:
        pinx = startpinx - fitnumpins * centercenterx + centercenterx / 2
      else:
        pinx = startpinx - fitnumpins * centercenterx
      indent = not indent
    return indent

def add_slots(space, x_init, y_init, total_h, total_w, slot_height, slot_separation, centered):
    centerline = x_init + total_w / 2
    quantityleft = (centerline - x_init) // slot_separation
    farleft = centerline - (slot_separation * quantityleft) + (slot_separation/2 * centered)

    body = pymunk.Body(body_type = pymunk.Body.STATIC)
    body.position = (0, 0)
    segments = []
    while farleft < x_init + total_w:
      segment = pymunk.Segment(body, (farleft, y_init), (farleft, y_init + total_h * slot_height / 100), 2)
      segments.append(segment)
      farleft = farleft + slot_separation

    space.add(*segments)

def main():
    pygame.init()
    screen = pygame.display.set_mode((600, 1000))
    pygame.display.set_caption("Galton Test")
    clock = pygame.time.Clock()

    space = pymunk.Space()
    space.gravity = (0.0, -900.0)


    # Create Board
    separation_distance = 5
    total_h = 900
    total_w = 500
    x_init = 50
    y_init = 50

    funnel_angle = 50  # deg
    funnel_height = 30 # per
    funnel_width = 55   # ??

    pin_total = 30     # per
    pin_diam = 10       # ??
    pin_horz = 31      # ??
    pin_vert = 26      # ??

    slot_height = 100 - funnel_height - pin_total - separation_distance * 2
    slot_separation = pin_horz + pin_diam + 5

    # outline
    add_outline(space, x_init, y_init, total_h, total_w)
    add_ramps(space, x_init, y_init, total_h, total_w, funnel_angle, funnel_height, funnel_width)
    centered = add_pins(space, x_init, y_init, total_h, total_w, funnel_height, separation_distance, pin_total, pin_diam, pin_horz, pin_vert)
    add_slots(space, x_init, y_init, total_h, total_w, slot_height, slot_separation, centered)

    add_balls(space, x_init, y_init, total_h, total_w, 15)
    balls = []
    draw_options = pymunk.pygame_util.DrawOptions(screen)

    while True:
        for event in pygame.event.get():
            if event.type == QUIT:
                sys.exit(0)
            elif event.type == KEYDOWN and event.key == K_ESCAPE:
                sys.exit(0)

        screen.fill((255,255,255))

        space.debug_draw(draw_options)

        space.step(1/50.0)

        pygame.display.flip()
        clock.tick(50)

if __name__ == '__main__':
    main()

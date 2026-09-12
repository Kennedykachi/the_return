from django.contrib.gis.geos import Point
from django.contrib.gis.measure import D
from rest_framework.viewsets import ReadOnlyModelViewSet

from .models import Experience
from .serializers import ExperienceSerializer


class ExperienceViewSet(ReadOnlyModelViewSet):
    serializer_class = ExperienceSerializer
    lookup_field = 'slug'

    def get_queryset(self):
        queryset = Experience.objects.filter(is_published=True)
        category = self.request.query_params.get('category')
        if category:
            queryset = queryset.filter(category=category)
        latitude = self.request.query_params.get('latitude')
        longitude = self.request.query_params.get('longitude')
        radius_km = self.request.query_params.get('radius_km')
        if latitude and longitude and radius_km:
            try:
                origin = Point(float(longitude), float(latitude), srid=4326)
                queryset = queryset.filter(location__distance_lte=(origin, D(km=float(radius_km))))
            except ValueError:
                return queryset.none()
        return queryset
